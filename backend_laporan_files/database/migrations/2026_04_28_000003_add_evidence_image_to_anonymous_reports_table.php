<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('anonymous_reports', function (Blueprint $table) {
            $table->string('evidence_image_path')->nullable()->after('source');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('anonymous_reports', function (Blueprint $table) {
            $table->dropColumn('evidence_image_path');
        });
    }
};

