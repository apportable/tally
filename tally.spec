Name:           tally
Version:        0.0.2
Release:        1%{?dist}
Summary:        Source code line counter
License:        ISC
URL:            https://github.com/craigbarnes/tally
BuildArch:      noarch
Source0:        %{url}/downloads/%{name}-%{version}.tar.gz

%description
%{summary}


%prep
%setup -q


%install
rm -rf %{buildroot}
make install PREFIX=%{_prefix} BINDIR=%{_bindir} DESTDIR=%{buildroot}


%files
%doc README.md
%{_bindir}/tally
%{_bindir}/stripcmt


%changelog

* Sun Jun 17 2012 Craig Barnes <cr@igbarn.es> - 0.0.2-1
- Update to latest version

* Mon Jun 04 2012 Craig Barnes <cr@igbarn.es> - 0.0.1-1
- Initial package
