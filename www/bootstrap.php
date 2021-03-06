<?php
/**
 * bootstrap.php
 * by @picas (me at picas dot fr)
 * <http://github.com/e-picas/dotfiles.git>
 * (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
 */

$basedir = dirname(__FILE__);

// simple flag to check if that file was loaded
@define('PHP_ENV_LOADED', true);

// Are we in command-line environment
define('IS_CLI', (bool) (strpos(php_sapi_name(),'cli')!==false));

//*/
// PHP default settings
@error_reporting(E_ALL | E_STRICT);
@ini_set('display_errors', 1);
$dtmz = @date_default_timezone_get();
@date_default_timezone_set($dtmz?:'UTC');
if (IS_CLI) {
    @ini_set('register_argc_argv', 1);
    @ini_set('html_errors', 0);
    if (function_exists('xdebug_disable')) {
        xdebug_disable();
    }
}
//*/

//*/
// initial settings
_settings('BASEPATH', $basedir);
_settings('CWD', getcwd());
//*/

//*/
// load user env
$env_file = _getPath(array($basedir, '.env'));
if (file_exists($env_file)) _loadUserEnv($env_file);
//*/

//*/
// Set the sources path in PHP global 'include_path' ...
set_include_path( get_include_path().PATH_SEPARATOR.$basedir );
if (@file_exists(($a = $basedir.'/src'))) {
	set_include_path( get_include_path().PATH_SEPARATOR.$a );
}
if (@file_exists(($b = $basedir.'/projects'))) {
	set_include_path( get_include_path().PATH_SEPARATOR.$b );
}
//*/

//*/
// include the Composer autoloader if COMPOSER_AUTOLOADER is `true` ...
if (defined('COMPOSER_AUTOLOADER') || COMPOSER_AUTOLOADER===true) {
	if (@file_exists($autoloader = _getPath(array($basedir, 'src', 'autoload.php')))) {
		require_once($autoloader);
	} else {
		trigger_error(sprintf('The Composer autoloader can not be found (searching "%s")!', $autoloader), E_USER_ERROR);
	}
}
//*/

/**
 * App settings setter/getter
 *
 *      _settings( (string)var , val )              : set 'var' on 'val'
 *      _settings( (string)var )                    : get 'var' current value
 *      _settings( (string)var , null , params )    : call 'var' closure with params 'params'
 *      _settings( (array)var )                     : set 'var' keys on 'var' values
 *      _settings()                                 : get the full current settings array
 *
 * @param null|string $name
 * @param null|mixed $value
 * @param null|array $params
 * @return array|null
 */
function _settings($name = null, $value = null, array $params = null)
{
    static $settings = array();
    if (is_array($name)) {
        $settings = array_merge($settings, $name);
    } elseif (!empty($name) && !empty($value)) {
        $settings[$name] = $value;
    } elseif (!empty($name)) {
        $val = isset($settings[$name]) ? $settings[$name] : null;
        if (!empty($val) && is_callable($val) && !empty($params)) {
            $val = call_user_func_array($val, $params);
        }
        return $val;
    }
    return $settings;
}

/**
 * Get a well-formatted path
 *
 * @param string|array $parts
 * @return string
 */
function _getPath($parts)
{
    return implode(DIRECTORY_SEPARATOR, array_map(
        function ($p) { return str_replace(array('/', '\\'), DIRECTORY_SEPARATOR, $p); },
        is_array($parts) ? $parts : array($parts)
    ));
}

/**
 * Load '.env' file variables in current environment
 *
 * @param bool $putenv Use 'putenv()' or 'settings()'
 * @return array
 */
function _loadUserEnv($filepath = null, $putenv = true)
{
    $vars   = array();
    $env    = _getPath(array(dirname(dirname(__FILE__)), '.env'));
    if (file_exists($filepath)) {
        $vars = @parse_ini_file($filepath, true);
        if (!empty($vars)) {
            foreach ($vars as $var=>$val) {
                if ($putenv) putenv($var.'='.$val);
                else _settings($var, $val);
            }
        }
    } else {
        trigger_error(sprintf('Environment file "%s" not found', $filepath), E_USER_ERROR);
    }
    return $vars;
}

/**
 * Debug anything
 */
function _debug()
{
    if (defined('HARD_DEBUG') && HARD_DEBUG===true) {
        foreach (func_get_args() as $var=>$val) {
            if (is_string($val)) {
                echo PHP_EOL . '# ' . $val . PHP_EOL;
            } else {
                try { var_export($val); }
                catch (Exception $e) { var_dump($val); }
            }
        }
    }
}
