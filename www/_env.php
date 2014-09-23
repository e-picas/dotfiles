<?php
#
# _env.php
# by @pierowbmstr (me at e-piwi dot fr)
# <http://github.com/piwi/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

// simple flag to check if that file was loaded
@define('PHP_ENV_LOADED', true);

//*/
// Show errors at least initially
//@ini_set('display_errors','1'); @error_reporting(E_ALL);                           // => for hard dev
//@ini_set('display_errors','1'); @error_reporting(E_ALL & ~E_STRICT);               // => for hard dev in PHP5.4 avoiding strict warnings
@ini_set('display_errors','1'); @error_reporting(E_ALL & ~E_NOTICE & ~E_STRICT);    // => classic setting
//*/

//*/
// Set a default timezone to avoid PHP5 warnings
$dtmz = @date_default_timezone_get();
date_default_timezone_set($dtmz?:'Europe/Paris');
//*/

//*/
// Set the sources path in PHP global 'include_path' ...
$basedir = realpath(__DIR__);
set_include_path( get_include_path().PATH_SEPARATOR.$basedir );
if (@file_exists(($a = $basedir.'/dependencies/src'))) {
    set_include_path( get_include_path().PATH_SEPARATOR.$a );
}
if (@file_exists(($b = $basedir.'/projects/src'))) {
    set_include_path( get_include_path().PATH_SEPARATOR.$b );
}
//*/
