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

  end

  def caveats
    <<~EOS
      To configure fonehome, read and edit this file:
        #{etc}/fonehome/fonehome.conf

      You will also need to install your secret key(s).

      After defining your server(s), confirm their public keys via:
        fonehome -I

      After changing the configuration, restart fonehome via:
        brew services restart fonehome

      See the fonehome(1) man page for futher details:
        man fonehome
    EOS
  end

  service do
    run [opt_bin/"fonehome"]
    keep_alive true
    working_dir var
  end

  test do
    system "#{bin}/fonehome", "--help"
  end
end
