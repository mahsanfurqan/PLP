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
        Schema::create('anonymous_reports', function (Blueprint $table) {
            $table->id();
            $table->string('student_name');
            $table->text('incident_description');
            $table->date('incident_date');
            $table->string('source', 20)->default('mobile');
            $table->timestamps();

            $table->index('incident_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('anonymous_reports');
    }
};
