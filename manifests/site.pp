# site.pp
# resource defaults and hiera_include

Package { allow_virtual => true, }
Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }

# set global variable $::role from hiera or from fact custom_role
# roles/$::role is also set as a level in hiera.yaml
# FACTER_custom_role=foo ./pulet apply
unless defined('$custom_role') { $custom_role = 'base' }
$role = lookup({name => 'role', default_value => $custom_role})

node default {
  #profiles:
  #  - profile::gitlab
  include profile::base
  lookup('profiles',           Array[String], 'unique', []).include
  lookup('additional_classes', Array[String], 'unique', []).include

  #additional_resources:
  #  - file:
  #      /tmp/foo:
  #        ensure: directory
  #  - notify:
  #      'hello world': {}
  #  - file:
  #      /tmp/bar:
  #        content: bar
  #      /tmp/bar2:
  #        content: bar2
  #  - notify:
  #      'hello world2': {}

  $additional_resources = lookup({
    name          => 'additional_resources',
    value_type    => Array[Hash],
    default_value => [],
    merge         => {
      strategy           => deep,
      sort_merged_arrays => false,
      merge_hash_arrays  => true,
    }
  })
  # Array of Hash: $additional_resources=[{file => {}},{notify=>{}}]
  $additional_resources.each |$resources| {
    # Hash: $resources={file => {}}
    $resources.each |$type, $resources_hash| {
      # Hash: file => {$r_name => $r_properties}
      $resources_hash.each |$r_name, $r_properties| {
        Resource[$type] {$r_name:
          * => $r_properties
        }
      }
    }
  }
}
