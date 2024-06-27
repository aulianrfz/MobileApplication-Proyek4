<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PdfController extends Controller
{
    public function uploadPdf(Request $request)
    {
        if ($request->hasFile('pdf')) {
            $path = $request->file('pdf')->store('pdfs');
            return response()->json(['url' => Storage::url($path)]);
        }

        return response()->json(['error' => 'No file uploaded'], 400);
    }

    public function downloadPdf($filename)
    {
        return Storage::download('pdfs/' . $filename);
    }
}
