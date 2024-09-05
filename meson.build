project('io.github.jellocodes.caffeinated', 'vala', 'c')

gettext_name = meson.project_name() + '-indicator'

prefix = get_option('prefix')
libdir = prefix / get_option('libdir')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

subdir('src')

