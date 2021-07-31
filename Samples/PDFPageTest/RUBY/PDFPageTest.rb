#---------------------------------------------------------------------------------------
# Copyright (c) 2001-2021 by PDFTron Systems Inc. All Rights Reserved.
# Consult LICENSE.txt regarding license information.
#---------------------------------------------------------------------------------------

require '../../../PDFNetC/Lib/PDFNetRuby'
include PDFNetRuby
require '../../LicenseKey/RUBY/LicenseKey'

$stdout.sync = true

	PDFNet.Initialize(PDFTronLicense.Key)
	
	# Relative path to the folder containing the test files.
	input_path = "../../TestFiles/"
	output_path = "../../TestFiles/Output/"

	# Sample 1 - Split a PDF document into multiple pages
	
	puts "_______________________________________________"
	puts "Sample 1 - Split a PDF document into multiple pages..."
	puts "Opening the input pdf..."
	in_doc = PDFDoc.new(input_path + "newsletter.pdf")
	in_doc.InitSecurityHandler
	
	page_num = in_doc.GetPageCount
	i = 1
	while i <= page_num do
		new_doc = PDFDoc.new
		new_doc.InsertPages(0, in_doc, i, i, PDFDoc::E_none)
		new_doc.Save(output_path + "newsletter_split_page_" + i.to_s + ".pdf", SDFDoc::E_remove_unused)
		puts "Done. Result saved in newsletter_split_page_" + i.to_s + ".pdf"
		new_doc.Close
		i = i + 1
	end
		
	# Close the open document to free up document memory sooner than waiting for the
	# garbage collector
	in_doc.Close

	# Sample 2 - Merge several PDF documents into one
	
	puts "_______________________________________________"
	puts "Sample 2 - Merge several PDF documents into one..."
	new_doc = PDFDoc.new
	new_doc.InitSecurityHandler
	
	page_num = 15
	i = 1
	while i <= page_num do
		puts "Opening newsletter_split_page_" + i.to_s + ".pdf"
		in_doc = PDFDoc.new(output_path + "newsletter_split_page_" + i.to_s + ".pdf")
		new_doc.InsertPages(i, in_doc, 1, in_doc.GetPageCount, PDFDoc::E_none)
		in_doc.Close
		i = i + 1
	end
		
	new_doc.Save(output_path + "newsletter_merge_pages.pdf", SDFDoc::E_remove_unused)
	puts "Done. Result saved in newsletter_merge_pages.pdf"

	# Close the open document to free up document memory sooner than waiting for the
	# garbage collector
	in_doc.Close
	
	# Sample 3 - Delete every second page
	
	puts "_______________________________________________"
	puts "Sample 3 - Delete every second page..."
	puts "Opening the input pdf..."
	in_doc = PDFDoc.new(input_path + "newsletter.pdf")
	in_doc.InitSecurityHandler
	page_num = in_doc.GetPageCount
	
	while page_num >= 1 do
		itr = in_doc.GetPageIterator(page_num)
		in_doc.PageRemove(itr)
		page_num = page_num - 2
	end

	in_doc.Save(output_path +  "newsletter_page_remove.pdf", 0)
	puts "Done. Result saved in newsletter_page_remove.pdf..."
	
	# Close the open document to free up document memory sooner than waiting for the
	# garbage collector
	in_doc.Close
	
	# Sample 4 - Inserts a page from one document at different 
	# locations within another document
	puts "_______________________________________________"
	puts "Sample 4 - Insert a page at different locations..."
	puts "Opening the input pdf..."
	
	in1_doc = PDFDoc.new(input_path +  "newsletter.pdf")
	in1_doc.InitSecurityHandler
	in2_doc = PDFDoc.new(input_path +  "fish.pdf")
	in2_doc.InitSecurityHandler
	
	src_page = in2_doc.GetPageIterator
	dst_page = in1_doc.GetPageIterator
	page_num = 1
    while dst_page.HasNext
        if page_num % 3 == 0
            in1_doc.PageInsert(dst_page, src_page.Current)
        end
        page_num = page_num + 1
        dst_page.Next
    end
	in1_doc.Save(output_path +  "newsletter_page_insert.pdf", 0)
	puts "Done. Result saved in newsletter_page_insert.pdf..."
	
	# Close the open document to free up document memory sooner than waiting for the
	# garbage collector
	in1_doc.Close
	in2_doc.Close
	
	# Sample 5 - Replicate pages within a single document
	puts "_______________________________________________"
	puts "Sample 5 - Replicate pages within a single document..."
	puts "Opening the input pdf..."
	
	doc = PDFDoc.new(input_path + "newsletter.pdf")
	doc.InitSecurityHandler
	
	# Replicate the cover page three times (copy page #1 and place it before the 
	# seventh page in the document page sequence)
	cover = doc.GetPage(1)
	p7 = doc.GetPageIterator(7)
	doc.PageInsert(p7, cover)
	doc.PageInsert(p7, cover)
	doc.PageInsert(p7, cover)
	
	# Replicate the cover page two more times by placing it before and after
	# existing pages.
	doc.PagePushFront(cover);
	doc.PagePushBack(cover)
	
	doc.Save(output_path +  "newsletter_page_clone.pdf", 0)
	puts "Done. Result saved in newsletter_page_clone.pdf..."
	doc.Close
	
	# Sample 6 - Use ImportPages in order to copy multiple pages at once 
	# in order to preserve shared resources between pages (e.g. images, fonts, 
	# colorspaces, etc.)
	puts "_______________________________________________"
	puts "Sample 6 - Preserving shared resources using ImportPages..."
	puts "Opening the input pdf..."
	in_doc = PDFDoc.new(input_path +  "newsletter.pdf")
	in_doc.InitSecurityHandler
	new_doc = PDFDoc.new
	copy_pages = VectorPage.new
	itr = in_doc.GetPageIterator
	while itr.HasNext do
		copy_pages << itr.Current
		itr.Next
	end
		
	imported_pages = new_doc.ImportPages(copy_pages)
	for x in imported_pages
		new_doc.PagePushFront(x)	# Order pages in reverse order. 
		# Use PagePushBack if you would like to preserve the same order.
	end
	
	new_doc.Save(output_path +  "newsletter_import_pages.pdf", 0)
	
	# Close the open document to free up document memory sooner than waiting for the
	# garbage collector
	in_doc.Close
	new_doc.Close
	PDFNet.Terminate
	puts "Done. Result saved in newsletter_import_pages.pdf..."
	puts "\nNote that the output file size is less than half the size"
	puts "of the file produced using individual page copy operations"
	puts "between two documents"

