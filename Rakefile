require 'puppetlabs_spec_helper/rake_tasks'
require 'puppetlabs_spec_helper/puppetlabs_spec_helper'
require 'puppet-lint/tasks/puppet-lint'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.ignore_paths = exclude_paths

desc "Create the fixtures directory"
task :spec_prep_win do
  # Ruby only sets File::ALT_SEPARATOR on Windows and Rubys standard library
  # uses this to check for Windows
  is_windows = !!File::ALT_SEPARATOR
  puppet_symlink_available = false
  begin
    require 'puppet/file_system'
    puppet_symlink_available = Puppet::FileSystem.respond_to?(:symlink)
  rescue
  end

  fixtures("repositories").each do |remote, opts|
    scm = 'git'
    if opts.instance_of?(String)
      target = opts
    elsif opts.instance_of?(Hash)
      target = opts["target"]
      ref = opts["ref"]
      scm = opts["scm"] if opts["scm"]
      branch = opts["branch"] if opts["branch"]
    end

    puts "clone #{scm} repository #{remote} into #{target}"
    
    unless File::exists?(target) || clone_repo(scm, remote, target, ref, branch)
      fail "Failed to clone #{scm} repository #{remote} into #{target}"
    end
    revision(scm, target, ref) if ref
  end

  FileUtils::mkdir_p("spec/fixtures/modules")
  fixtures("symlinks").each do |source, target|
    FileUtils::mkdir_p(target);
    x = Dir.glob( source + '/*').reject{|entry| entry["spec"]}
    FileUtils::cp_r(x, target, :remove_destination => true)
  end

  fixtures("forge_modules").each do |remote, opts|
    if opts.instance_of?(String)
      target = opts
      ref = ""
    elsif opts.instance_of?(Hash)
      target = opts["target"]
      ref = "--version #{opts['ref']}"
    end
    next if File::exists?(target)
    unless system("puppet module install " + ref + \
                  " --ignore-dependencies" \
                  " --force" \
                  " --target-dir spec/fixtures/modules #{remote}")
      fail "Failed to install module #{remote} to #{target}"
    end
  end

  FileUtils::mkdir_p("spec/fixtures/manifests")
  FileUtils::touch("spec/fixtures/manifests/site.pp")
end