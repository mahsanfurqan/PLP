<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AnonymousReportNotification extends Model
{
    protected $fillable = [
        'anonymous_report_id',
        'coordinator_id',
        'title',
        'message',
        'is_read',
        'read_at',
    ];

    protected $casts = [
        'is_read' => 'boolean',
        'read_at' => 'datetime',
    ];

    public function anonymousReport()
    {
        return $this->belongsTo(AnonymousReport::class);
    }

    public function coordinator()
    {
        return $this->belongsTo(User::class, 'coordinator_id');
    }
}
