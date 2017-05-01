# elinux-tools
Tools for Embedded Linux Development.

## Prerequisites

Debian/Ubuntu:

```text
apt-get install -y pxz jq kpartx pv squashfs-tools qemu-user-static
```



## Benchmark for Compression Sizes

```text
677	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb-20170405183057
710	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.img
170	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.img.xz
599	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.1
176	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.1.xz
418	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.2
224	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.3
223	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.4
224	/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sxz
```

| file | size | description | 
|---|---|---|
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.img.xz` | 170MB | Original compressed device image downloaded from elinux site |
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.img` | 710MB | device image |
| `/tmp/bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb-20170405183057` | 677MB | archive directory extracted from device image |
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.1` | 176MB | squashfs `-comp xz -noI -noD -noF -no-duplicates` (almost no compression) |
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.1.xz` | 599MB | squashfs `-comp xz -noI -noD -noF -no-duplicates`, but then run `xz` on this file to compress |
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.2` | 418MB | squashfs `-comp xz -noI -noD -no-duplicates` |
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.3` | 224MB | squashfs `-comp xz -noI -no-duplicates` |
| `bone-ubuntu-14.04.3-console-armhf-2016-02-11-2gb.sqfs.4` | 223MB | squashfs `-comp xz -no-duplicates` |

Conclusion: `.sqfs.xz` is better, because it allows random access, and almost no speed lost when copying all files under sqfs (when it is mounted at lower layer of overlayfs). It is also good for network transmission after compression.



## Similar Tools

- [linuxkit](https://github.com/linuxkit/linuxkit)
