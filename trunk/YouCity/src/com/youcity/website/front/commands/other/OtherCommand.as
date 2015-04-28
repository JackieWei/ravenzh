package com.youcity.website.front.commands.other
{
	import com.youcity.website.front.business.IServiceDelegate;
//	
	import com.youcity.website.front.commands.CommandBase;
	import com.youcity.website.front.model.OtherModelLocator;

	public class OtherCommand extends CommandBase
	{
		public var otherModel:OtherModelLocator = OtherModelLocator.getInstance();

		public function OtherCommand()
		{
			super();
		}
		
	}
}