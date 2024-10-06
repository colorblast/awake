wingpanel_dep = dependency('wingpanel')
wingpanel_indicatorsdir = wingpanel_dep.get_variable('indicatorsdir', pkgconfig_define: ['libdir', libdir])

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('granite', version: '>=6.0.0'),
    dependency('gtk+-3.0'),
    meson.get_compiler('vala').find_library('posix'),
    wingpanel_dep,
]

gnome = import('gnome')
gresource = gnome.compile_resources(
    'gresource',
    '../data/resources.xml',
    source_dir: '../data',
    install: false,
)

files = files(
    'Indicator.vala',

)

shared_module(
    meson.project_name(),
    files + gresource,
    dependencies: dependencies,
    install: true,
    install_dir: wingpanel_indicatorsdir,
)