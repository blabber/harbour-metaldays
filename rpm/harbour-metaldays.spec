# Prevent brp-python-bytecompile from running
%define __os_install_post %{___build_post}

Summary: An unofficial MetalDays running order for Sailfish OS
Name: harbour-metaldays
Version: 0.1.1
Release: 1
Source: %{name}-%{version}.tar.gz
BuildArch: noarch
URL: https://github.com/blabber/harbour-metaldays
License: Beerware
Group: Applications/Internet
Requires: sailfishsilica-qt5
Requires: pyotherside-qml-plugin-python3-qt5 >= 1.3.0
Requires: libsailfishapp-launcher

%description
This is an unofficial Sailfish OS app to display the running order of
MetalDays[1] festival in slovenia. 

As there is no official API to access the running order, this app uses the
mdjson[2] backend.

[1]: http://metaldays.net
[2]: https://github.com/blabber/mdjson

%prep
%setup -q

%build
# Nothing to do

%install

TARGET=%{buildroot}/%{_datadir}/%{name}
mkdir -p $TARGET
cp -rpv python $TARGET/
cp -rpv qml $TARGET/
cp -rpv img $TARGET/

TARGET=%{buildroot}/%{_datadir}/applications
mkdir -p $TARGET
cp -rpv %{name}.desktop $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/86x86/apps/
mkdir -p $TARGET
cp -rpv icons/86x86/%{name}.png $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/108x108/apps/
mkdir -p $TARGET
cp -rpv icons/108x108/%{name}.png $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/128x128/apps/
mkdir -p $TARGET
cp -rpv icons/128x128/%{name}.png $TARGET/

TARGET=%{buildroot}/%{_datadir}/icons/hicolor/256x256/apps/
mkdir -p $TARGET
cp -rpv icons/256x256/%{name}.png $TARGET/

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png

