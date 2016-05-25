# == Define: nrpe::collisioncheck
#
# Check for colliding hash keys in $plugins and $rawconfig to avoid
# conflicting file names
#
define nrpe::collisioncheck($content) {
  if has_key($nrpe::plugins, $name) {
    fail("There are colliding hash keys in \$plugins and \$rawconfig. Key \'${name}\' was found in both hashes.")
  }
}
