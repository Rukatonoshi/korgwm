#!/usr/bin/perl
# made by: KorG
# vim: cc=119 et sw=4 ts=4 :
package X11::korgwm::Xkb;
use strict;
use warnings;
use feature 'signatures';

use X11::XCB ':all';
use X11::korgwm::Common;
require X11::korgwm::Panel::Lang;

# Update language on the panel
sub lang_update {
    my $lang = $X->xkb_get_state_reply($X->xkb_get_state(XKB_ID_USE_CORE_KBD)->{sequence})->{group};
    $lang = $cfg->{lang_names}->{$lang} // $lang;
    $_->{panel}->lang_set($lang) for values %screens;
}

sub init {
    # Set up extension
    my $XKB_EVENT_BASE;
    $X->xkb_use_extension(1, 1);
    init_extension("XKEYBOARD", \$XKB_EVENT_BASE);
    croak "Unable to init Xkb" unless $XKB_EVENT_BASE;

    # Set up event handler
    add_event_cb($XKB_EVENT_BASE, sub($evt) {
        # We ignore pad0 and update notifier on any xkb event
        lang_update();
    });

    # Subscribe for events
    my $mask = XKB_EVENT_TYPE_INDICATOR_STATE_NOTIFY;
    $X->xkb_select_events(XKB_ID_USE_CORE_KBD, $mask, 0, $mask, 0, 0, 0);
    $X->flush();

    # Show current lang
    lang_update();
}

push @X11::korgwm::extensions, \&init;

1;
