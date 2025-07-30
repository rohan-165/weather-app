String fixIconUrl(String path) {
  if (path.startsWith('//')) {
    return 'https:$path';
  }
  return path;
}
