<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Auth\RegisteredUserController;
use App\Http\Controllers\AnonymousReportController;
use App\Http\Controllers\KeminatanController;
use App\Http\Controllers\LogbookController;
use App\Http\Controllers\SmkController;
use App\Http\Controllers\PendaftaranPlpController;
use App\Http\Controllers\ValidasiLogbookController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [RegisteredUserController::class, 'store']);
Route::post('/login', [AuthenticatedSessionController::class, 'store']);
Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->middleware('auth:sanctum');
Route::post('/laporan-anonim', [AnonymousReportController::class, 'store']);


Route::middleware('auth:sanctum')->group(function () {

    Route::get('/laporan-anonim', [AnonymousReportController::class, 'index'])->middleware('role:Dosen Koordinator');
    Route::patch('/laporan-anonim/{id}/read', [AnonymousReportController::class, 'markAsRead'])->middleware('role:Dosen Koordinator');

    Route::prefix('/akun')->group(function () {
        Route::get('/dospem', [RegisteredUserController::class, 'indexDospem']);
        Route::get('/pamong', [RegisteredUserController::class, 'indexPamong']);
        Route::get('/kaprodi', [RegisteredUserController::class, 'indexKaprodi']);
        Route::get('/koordinator', [RegisteredUserController::class, 'indexKoordinator']);
        Route::get('/pj', [RegisteredUserController::class, 'indexPJ']);
    });

    Route::post('/pembuatan-akun', [RegisteredUserController::class, 'pembuatanAkun'])->middleware('role:Akademik');

    Route::prefix('/logbooks')->group(function () {
        Route::get('/', [LogbookController::class, 'index'])->middleware('role:Kaprodi,Mahasiswa');
        Route::post('/', [LogbookController::class, 'store'])->middleware('role:Mahasiswa');
        Route::get('/all', [LogbookController::class, 'indexAll'])->middleware('role:Kaprodi,Akademik,Dosen Koordinator');
        Route::get('/validasi', [LogbookController::class, 'indexByGuru'])->middleware('role:Guru,Dosen Pembimbing');
        Route::put('/validasi/{id}', [ValidasiLogbookController::class, 'updateSingleApproverStatus'])->middleware('role:Guru,Dosen Pembimbing');
        Route::delete('/delete/{id}', [LogbookController::class, 'destroy'])->middleware('role:Mahasiswa');
    });

    Route::prefix('smk')->group(function () {
        Route::get('/', [SmkController::class, 'index'])->middleware('role:Kaprodi,Dosen Koordinator,Akademik,Mahasiswa');
        Route::post('/', [SmkController::class, 'store'])->middleware('role:Kaprodi,Dosen Koordinator,Akademik');
    });

    Route::prefix('keminatan')->group(function () {
        Route::get('/', [KeminatanController::class, 'index']);
        Route::post('/', [KeminatanController::class, 'store'])->middleware('role:Kaprodi,Dosen Koordinator,Akademik');
    });

    Route::prefix('pendaftaran-plp')->group(function () {
        Route::get('/', [PendaftaranPlpController::class, 'index']);
        Route::get('/all', [PendaftaranPlpController::class, 'indexAll'])->middleware('role:Kaprodi,Dosen Koordinator,Akademik');
        Route::post('/', [PendaftaranPlpController::class, 'store'])->middleware('role:Mahasiswa');
        Route::patch('/{id}', [PendaftaranPlpController::class, 'assign'])->middleware('role:Kaprodi,Dosen Koordinator');
    });
});
