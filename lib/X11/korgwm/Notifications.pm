#!/usr/bin/perl
# made by: KorG
# vim: cc=119 et sw=4 ts=4 :

# Additional package to avoid any casual namespace mess with Net::DBus::Exporter
package Notifications;
use strict;
use warnings;
use feature 'signatures';

use X11::korgwm::Common;
use Net::DBus::Exporter qw(org.freedesktop.Notifications);
use base qw(Net::DBus::Object);

my $id = 1;

sub new($class, $service) {
    my $self = $class->SUPER::new($service, "/org/freedesktop/Notifications");
    bless $self, $class;
}

dbus_method("Notify",
    [ "string", "uint32", "string", "string", "string", [array => "string"], [dict => "string", "string"], "int32" ],
    [ "uint32" ]
);
sub Notify {
    # See libnotify/notification-spec.xml for more info
    my ($self, $app_name, $replace_id, $icon, $summary, $body, $actions, $hints, $expiration) = @_;
    DEBUG9 and carp sprintf "Got D-Bus notification: (%s)", join ", ", map { $_ // "" }
        $app_name, $replace_id, $icon, $summary, $body, $expiration;

    # So far I'll ignore messages with urgency == 0
    if (ref $hints eq 'HASH' && $hints->{urgency}) {
        # Make a window w/ WM_CLASS == ($app_name OR $icon OR $hints->{desktop-entry}) urgent if single match
        my @found = &X11::korgwm::Window::urgent_by_class($app_name, $icon, $hints->{"desktop-entry"});

        DEBUG7 and carp sprintf "Got urgent notification for windows [%s] with class one of (%s)", "@found",
            join "|", map { $_ // "" } $app_name, $icon, $hints->{'desktop-entry'};
    }

    return $id++;
}

dbus_method("GetCapabilities", [], [ [ array => "string" ] ]);
sub GetCapabilities { [ "body" ] }

dbus_method("CloseNotification", [ "uint32" ], []);
sub CloseNotification { 1 }

dbus_signal("NotificationClosed", [ "uint32", "uint32" ]);
sub NotificationClosed { 1 }

dbus_method("GetServerInformation", [], [ ("string") x 4 ]);
sub GetServerInformation { ("Trimming The Herbs", "korgwm", "1.0", "1.2") }

package X11::korgwm::Notifications;
use strict;
use warnings;
use feature 'signatures';

use Carp;
use Net::DBus;
use AnyEvent::DBus;
use X11::korgwm::Common;

# Establish Notifications server
sub init {
    return unless $cfg->{notification_server};
    my $bus = Net::DBus->session();
    my $service = $bus->export_service("org.freedesktop.Notifications");
    Notifications->new($service);
}

push @X11::korgwm::extensions, \&init;

1;
