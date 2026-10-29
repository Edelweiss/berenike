<?php

namespace App\EventListener;

/**
 * Entity listener for logging changes to Correction and Task entities
 */
class Loggable
{
    public function postCorrectionPersist(): void
    {
    }

    public function postCorrectionUpdate(): void
    {
    }

    public function preCorrectionRemove(): void
    {
    }

    public function postTaskPersist(): void
    {
    }

    public function postTaskUpdate(): void
    {
    }
}
