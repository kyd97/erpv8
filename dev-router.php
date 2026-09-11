<?php
/**
 * Router script for PHP's built-in development server.
 *
 * CodeIgniter 2 needs every non-asset request funnelled through index.php while
 * static files under /statics and /data are still served straight from disk.
 */
$root = __DIR__;
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$file = $path === null ? false : realpath($root . $path);

if ($path !== '/' && $file !== false && is_file($file) && strpos($file, $root) === 0) {
	return false;
}

$_SERVER['SCRIPT_NAME'] = '/index.php';
$_SERVER['SCRIPT_FILENAME'] = $root . '/index.php';
$_SERVER['PHP_SELF'] = '/index.php';

require $root . '/index.php';
