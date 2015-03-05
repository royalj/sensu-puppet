# = Define: sensu::mutator
#
# Defines Sensu mutators
#
# == Parameters
#
# [*command*]
#   String.  The mutator command to run
#   Required
#
# [*ensure*]
#   String. Whether the check should be present or not
#   Default: present
#   Valid values: present, absent
#

define sensu::mutator(
  $command,
  $ensure   = 'present',
) {

  validate_re($ensure, ['^present$', '^absent$'] )

  $mutator_name = regsubst(regsubst($name, ' ', '_', 'G'), '[\(\)]', '', 'G')

  file { '/etc/sensu/conf.d/mutators':
    ensure  => 'directory',
    owner   => 'sensu',
    group   => 'sensu',
  }

  file { "/etc/sensu/conf.d/mutators/${mutator_name}.json":
    ensure => $ensure,
    owner  => 'sensu',
    group  => 'sensu',
    mode   => '0440',
    content => template("${module_name}/mutator.json.erb"),
  }
}