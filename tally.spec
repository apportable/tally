Name:           tally
Version:        0.0.1
Release:        1%{?dist}
Summary:        Source code line counter
License:        ISC
URL:            https://github.com/craigbarnes/tally
Source0:        %{url}/downloads/%{name}-%{version}.tar.gz
Requires:       lua-filesystem

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


%changelog

* Mon Jun 04 2012 Craig Barnes <cr@igbarn.es> - 0.0.1-1
- Initial package
