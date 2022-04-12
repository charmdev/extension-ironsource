#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "IronSourceEx.h"

using namespace ironsourceex;

AutoGCRoot* is_adsEventHandle = 0;

#ifdef IPHONE

static void ISads_set_event_handle(value onEvent)
{
	is_adsEventHandle = new AutoGCRoot(onEvent);
}
DEFINE_PRIM(ISads_set_event_handle, 1);

static value ironsourceex_init(value appkey){
	init(val_string(appkey));
	return alloc_null();
}
DEFINE_PRIM(ironsourceex_init,1);

static value ironsourceex_show_rewarded(){
	showRewarded();
	return alloc_null();
}
DEFINE_PRIM(ironsourceex_show_rewarded,0);

#endif

extern "C" void ironsourceex_main () {	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (ironsourceex_main);

extern "C" int ironsourceex_register_prims () { return 0; }

extern "C" void ISsendAdsEvent(const char* type)
{
	printf("IS Send Event: %s\n", type);

	if (type)
	{
		value o = alloc_empty_object();
		alloc_field(o,val_id("type"),alloc_string(type));
		val_call1(is_adsEventHandle->get(), o);
	}
	
}
