#---------------------------------------------------------------------------------------
# Copyright (c) 2001-2024 by Apryse Software Inc. All Rights Reserved.
# Consult LICENSE.txt regarding license information.
#---------------------------------------------------------------------------------------

require '../../../PDFNetC/Lib/PDFNetRuby'
include PDFNetRuby
require '../../LicenseKey/RUBY/LicenseKey'

$stdout.sync = true

# The following sample illustrates how to print PDF document using currently selected
# default printer. 
# 
# The first example uses the new PDF::Print::StartPrintJob function to send a rasterization 
# of the document with optimal compression to the printer.  If the OS is Windows 7, then the
# XPS print path will be used to preserve vector quality.  For earlier Windows versions
# the GDI print path will be used.  On other operating systems this will be a no-op
# 
# The second example uses PDFDraw send unoptimized rasterized data via awt.print API. 
# 
# If you would like to rasterize page at high resolutions (e.g. more than 600 DPI), you 
# should use PDFRasterizer or PDFNet vector output instead of PDFDraw.

	if ENV['OS'] == 'Windows_NT' 
		PDFNet.Initialize(PDFTronLicense.Key)
	
		# Relative path to the folder containing the test files.
		input_path = "../../TestFiles/"
		
		doc = PDFDoc.new(input_path + "tiger.pdf")
		doc.InitSecurityHandler
		
		# Set our PrinterMode options
		printerMode = PrinterMode.new
		printerMode.SetCollation(true)
		printerMode.SetCopyCount(1)
		printerMode.SetDPI(100)		# regardless of ordering, an explicit DPI setting overrides the OutputQuality setting
		printerMode.SetDuplexing(PrinterMode::E_Duplex_Auto)
		
		# If the XPS print path is being used, then the printer spooler file will
		# ignore the grayscale option and be in full color
		printerMode.SetOutputColor(PrinterMode::E_OutputColor_Grayscale)
		printerMode.SetOutputQuality(PrinterMode::E_OutputQuality_Medium)
		# printerMode.SetNUp(2,1)
		# printerMode.SetScaleType(PrinterMode.e_ScaleType_FitToOutPage)
		
		# Print the PDF document to the default printer, using "tiger.pdf" as the document
		# name, send the file to the printer not to an output file, print all pages, set the printerMode
		# and don't provide a cancel flag.
		Print.StartPrintJob(doc, "", doc.GetFileName(), "", nil, printerMode, nil)
		PDFNet.Terminate
		puts "Done."
	else
		puts "This sample cannot be executed on this platform."
	end
