class Fonehome < Formula
  desc "Remote access to machines behind firewalls"
  homepage "https://github.com/archiecobbs/fonehome"
  url "https://s3.amazonaws.com/archie-public/fonehome/fonehome-1.2.1.tar.gz"
  sha256 "8df8f43b2b9f0ab62eb188cf7cbb0b4fc93ac436af24217cdaa7858d82556674"

  def install
    build_script = <<~EOS

      SCRIPTFILE="#{bin}/fonehome"
      CONFDIR="#{HOMEBREW_PREFIX}/etc/fonehome"
      LAUNCHFILE="#{launchd_service_path}"
      CONFFILE="${CONFDIR}/fonehome.conf"
      KEYFILE="${CONFDIR}/fonehome.key"
      HOSTSFILE="${CONFDIR}/fonehome.hosts"
      RETRYDELAY="30"
      USERNAME="fonehome"
      SYSLOGFAC="daemon"

      subst()
      {
          sed \
            -e "s|@fonehomeconf@|${CONFFILE}|g" \
            -e "s|@fonehomehosts@|${HOSTSFILE}|g" \
            -e "s|@fonehomeinit@|${LAUNCHFILE}|g" \
            -e "s|@fonehomekey@|${KEYFILE}|g" \
            -e "s|@fonehomelogfac@|${SYSLOGFAC}|g" \
            -e "s|@fonehomename@|fonehome|g" \
            -e "s|@fonehomeretry@|${RETRYDELAY}|g" \
            -e "s|@fonehomeuser@|${USERNAME}|g"
      }
      subst < src/conf/fonehome.conf.sample > fonehome.conf.sample
      subst < src/scripts/fonehome.sh > fonehome
      subst < src/man/fonehome.1 > fonehome.1

      # man pages
      install -d "#{man1}"
      install fonehome.1 "#{man1}/"

      # docs
      install -d "#{doc}"
      install CHANGES README COPYING fonehome.conf.sample "#{doc}/"

      # script files
      install -d "#{bin}"
      install fonehome "#{bin}/"

      # config files
      install -d "${CONFDIR}"
      install fonehome.conf.sample "${CONFFILE}"

      # Create empty host and key files
      install /dev/null "${HOSTSFILE}"
      install /dev/null "${KEYFILE}"
      chmod 600 "${KEYFILE}"

    EOS

    Open3.capture2("bash", :stdin_data=>build_script, :binmode=>true)

    launchd_service_path.write fonehome_startup_plist
    launchd_service_path.chmod 0644

    ohai "See fonehome(1) man page for setup and initialization instructions."
  end

  test do
    system "#{bin}/fonehome", "--help"
  end

  def fonehome_startup_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/fonehome</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
  EOS
  end
end
