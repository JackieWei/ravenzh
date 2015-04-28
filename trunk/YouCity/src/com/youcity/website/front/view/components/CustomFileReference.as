package com.youcity.website.front.view.components
{
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class CustomFileReference extends flash.net.FileReference
	{
		public function CustomFileReference()
		{
			super();
		}
		
		public function getTypes():Array 
		{
	        var allTypes:Array = new Array();
	        allTypes.push(getImageTypeFilter());
	        //allTypes.push(getTextTypeFilter());
	        return allTypes;
	    }
	 
	    private function getImageTypeFilter():FileFilter {
	        return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
	    }
	 
	    private function getTextTypeFilter():FileFilter {
	        return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
	    }
		
	}
}