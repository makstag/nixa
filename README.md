riscv64 [kernel sv48](https://docs.kernel.org/6.3/riscv/vm-layout.html)

```
========================================================================================================================
     Start addr    |   Offset   |     End addr     |  Size   | VM area description
========================================================================================================================
                   |            |                  |         |
  0000000000000000 |    0       | 00007fffffffffff |  128 TB | user-space virtual memory, different per mm
 __________________|____________|__________________|_________|___________________________________________________________
                   |            |                  |         |
  0000800000000000 | +128    TB | ffff7fffffffffff | ~16M TB | ... huge, almost 64 bits wide hole of non-canonical
                   |            |                  |         | virtual memory addresses up to the -128 TB
                   |            |                  |         | starting offset of kernel mappings.
 __________________|____________|__________________|_________|___________________________________________________________
                                                             |
                                                             | Kernel-space virtual memory, shared between all processes:
 ____________________________________________________________|___________________________________________________________
                   |            |                  |         |
  ffff8d7ffea00000 |  -114.5 TB | ffff8d7ffeffffff |    6 MB | fixmap
  ffff8d7fff000000 |  -114.5 TB | ffff8d7fffffffff |   16 MB | PCI io
  ffff8d8000000000 |  -114.5 TB | ffff8f7fffffffff |    2 TB | vmemmap
  ffff8f8000000000 |  -112.5 TB | ffffaf7fffffffff |   32 TB | vmalloc/ioremap space
  ffffaf8000000000 |  -80.5  TB | ffffef7fffffffff |   64 TB | direct mapping of all physical memory
  ffffef8000000000 |  -16.5  TB | fffffffeffffffff | 16.5 TB | kasan
 __________________|____________|__________________|_________|____________________________________________________________
                                                             |
                                                             | Identical layout to the 39-bit one from here on:
 ____________________________________________________________|____________________________________________________________
                   |            |                  |         |
  ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | modules, BPF
  ffffffff80000000 |   -2    GB | ffffffffffffffff |    2 GB | kernel
 __________________|____________|__________________|_________|____________________________________________________________

```
