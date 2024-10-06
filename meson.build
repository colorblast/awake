project('io.github.colorblast.awake', 'vala', 'c')

gettext_name = meson.project_name() + '-indicator'

prefix = get_option('prefix')
libdir = prefix / get_option('libdir')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language: 'c')

gnome = import('gnome')
gnome.post_install(glib_compile_schemas: true)

subdir('src')
subdir('data')