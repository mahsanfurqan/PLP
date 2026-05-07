<?php

namespace App\Http\Controllers;

use App\Models\AnonymousReport;
use App\Models\AnonymousReportNotification;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class AnonymousReportController extends Controller
{
    public function index(Request $request)
    {
        $user = Auth::user();

        $reports = AnonymousReport::with([
            'coordinatorNotifications' => function ($query) use ($user) {
                $query->where('coordinator_id', $user->id)
                    ->select('id', 'anonymous_report_id', 'is_read', 'read_at');
            }
        ])->latest()->get();

        $formatted = $reports->map(function ($report) {
            $notification = $report->coordinatorNotifications->first();

            return [
                'id' => $report->id,
                'student_name' => $report->student_name,
                'incident_description' => $report->incident_description,
                'incident_date' => $report->incident_date,
                'source' => $report->source,
                'evidence_image_url' => $report->evidence_image_path
                    ? url(Storage::disk('public')->url($report->evidence_image_path))
                    : null,
                'created_at' => $report->created_at,
                'updated_at' => $report->updated_at,
                'is_read' => $notification?->is_read ?? false,
                'read_at' => $notification?->read_at,
            ];
        })->values();

        return response()->json($formatted, 200);
    }

    public function markAsRead($id)
    {
        $user = Auth::user();

        $notification = AnonymousReportNotification::where('anonymous_report_id', $id)
            ->where('coordinator_id', $user->id)
            ->first();

        if (!$notification) {
            return response()->json([
                'message' => 'Data notifikasi pelaporan tidak ditemukan.'
            ], 404);
        }

        if (!$notification->is_read) {
            $notification->is_read = true;
            $notification->read_at = now();
            $notification->save();
        }

        return response()->json([
            'message' => 'Laporan berhasil ditandai sebagai dibaca.',
            'data' => [
                'anonymous_report_id' => (int) $notification->anonymous_report_id,
                'is_read' => (bool) $notification->is_read,
                'read_at' => $notification->read_at,
            ],
        ], 200);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'student_name' => 'required|string|max:150',
            'incident_description' => 'required|string|max:5000',
            'incident_date' => 'required|date|before_or_equal:today',
            'evidence_image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:4096',
        ]);

        DB::beginTransaction();

        try {
            $evidenceImagePath = null;
            if ($request->hasFile('evidence_image')) {
                $evidenceImagePath = $request->file('evidence_image')
                    ->store('anonymous-reports', 'public');
            }

            $report = AnonymousReport::create([
                'student_name' => $validated['student_name'],
                'incident_description' => $validated['incident_description'],
                'incident_date' => $validated['incident_date'],
                'source' => 'mobile',
                'evidence_image_path' => $evidenceImagePath,
            ]);

            $coordinators = User::where('role', 'Dosen Koordinator')->get(['id']);

            if ($coordinators->isNotEmpty()) {
                $notifications = $coordinators->map(function ($coordinator) use ($report) {
                    return [
                        'anonymous_report_id' => $report->id,
                        'coordinator_id' => $coordinator->id,
                        'title' => 'Laporan anonim masuk',
                        'message' => "Laporan baru terkait mahasiswa {$report->student_name} pada tanggal {$report->incident_date->format('d-m-Y')}.",
                        'is_read' => false,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                })->toArray();

                AnonymousReportNotification::insert($notifications);
            }

            DB::commit();

            return response()->json([
                'message' => 'Laporan berhasil dikirim.',
                'data' => [
                    'id' => $report->id,
                    'student_name' => $report->student_name,
                    'incident_description' => $report->incident_description,
                    'incident_date' => $report->incident_date,
                    'source' => $report->source,
                    'evidence_image_url' => $report->evidence_image_path
                        ? url(Storage::disk('public')->url($report->evidence_image_path))
                        : null,
                    'created_at' => $report->created_at,
                    'updated_at' => $report->updated_at,
                ],
                'coordinator_notified_count' => $coordinators->count(),
            ], 201);
        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Gagal mengirim laporan anonim.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
