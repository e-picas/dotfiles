<?php

umask(022);
$base_path = dirname(__FILE__);
require_once $base_path . DIRECTORY_SEPARATOR . 'bootstrap.php';

// parse INI projects list
$projects_list_ini = _getPath(array($base_path, 'projects.ini'));
if (file_exists($projects_list_ini)) {
    $projects_list = parse_ini_file($projects_list_ini, true);
} else {
    die(
        sprintf('Projects INI list not found at "%s"', $projects_list_ini)
    );
}

// clone each project in its final place
$projects_dir = _getPath(array($base_path, 'projects'));
if (!file_exists($projects_dir)) {
    mkdir($projects_dir);
}
foreach ($projects_list as $namespace=>$projects) {
    $namespace_dir = _getPath(array($projects_dir, $namespace));
    if (!file_exists($namespace_dir)) {
        mkdir($namespace_dir);
    }
    foreach ($projects as $url) {
        $project_dir = $namespace_dir . DIRECTORY_SEPARATOR . str_replace('.git', '', basename($url));
        if (!file_exists($project_dir)) {
            echo "> creating clone of " . $url.PHP_EOL;
            exec(
                sprintf('cd %s && git clone %s', $namespace_dir, $url)
            );
        } else {
            echo "> updating clone of " . $url.PHP_EOL;
            exec(
                sprintf('cd %s && git pull', $project_dir)
            );
        }
    }
}
