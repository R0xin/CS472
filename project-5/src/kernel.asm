
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 20 71 10 80       	push   $0x80107120
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 45 41 00 00       	call   801041a0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 71 10 80       	push   $0x80107127
80100097:	50                   	push   %eax
80100098:	e8 d3 3f 00 00       	call   80104070 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 17 42 00 00       	call   80104300 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 49 42 00 00       	call   801043b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 3f 00 00       	call   801040b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 1f 00 00       	call   801020e0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 71 10 80       	push   $0x8010712e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 9d 3f 00 00       	call   80104150 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 17 1f 00 00       	jmp    801020e0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 71 10 80       	push   $0x8010713f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 5c 3f 00 00       	call   80104150 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 3f 00 00       	call   80104110 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 f0 40 00 00       	call   80104300 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 4f 41 00 00       	jmp    801043b0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 71 10 80       	push   $0x80107146
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 14 00 00       	call   80101740 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 6f 40 00 00       	call   80104300 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 4e 3a 00 00       	call   80103d10 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 89 34 00 00       	call   80103760 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 c5 40 00 00       	call   801043b0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 6d 13 00 00       	call   80101660 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 65 40 00 00       	call   801043b0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 0d 13 00 00       	call   80101660 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 52 23 00 00       	call   801026e0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 4d 71 10 80       	push   $0x8010714d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 9f 7a 10 80 	movl   $0x80107a9f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 03 3e 00 00       	call   801041c0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 61 71 10 80       	push   $0x80107161
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 01 57 00 00       	call   80105b20 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 48 56 00 00       	call   80105b20 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 3c 56 00 00       	call   80105b20 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 30 56 00 00       	call   80105b20 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 97 3f 00 00       	call   801044b0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 d2 3e 00 00       	call   80104400 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 65 71 10 80       	push   $0x80107165
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 90 71 10 80 	movzbl -0x7fef8e70(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 2c 11 00 00       	call   80101740 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 e0 3c 00 00       	call   80104300 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 64 3d 00 00       	call   801043b0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 10 00 00       	call   80101660 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 9e 3c 00 00       	call   801043b0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 78 71 10 80       	mov    $0x80107178,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 33 3b 00 00       	call   80104300 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 7f 71 10 80       	push   $0x8010717f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 f8 3a 00 00       	call   80104300 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 43 3b 00 00       	call   801043b0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 c5 35 00 00       	call   80103ec0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 34 36 00 00       	jmp    80103fb0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 88 71 10 80       	push   $0x80107188
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 eb 37 00 00       	call   801041a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 b2 18 00 00       	call   80102290 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 5f 2d 00 00       	call   80103760 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 34 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 99 14 00 00       	call   80101eb0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 33 0c 00 00       	call   80101660 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 02 0f 00 00       	call   80101940 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 a1 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a4f:	e8 5c 21 00 00       	call   80102bb0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 37 62 00 00       	call   80106cb0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  //changed to 4096 (PGSIZE)
  sz = PGSIZE;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x1000,-0x114(%ebp)
80100a98:	10 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 73 0e 00 00       	call   80101940 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 f7 5f 00 00       	call   80106b00 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 01 5f 00 00       	call   80106a40 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 d2 60 00 00       	call   80106c30 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 81 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b6f:	e8 3c 20 00 00       	call   80102bb0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 66 5f 00 00       	call   80106b00 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 7f 60 00 00       	call   80106c30 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 ed 1f 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 a1 71 10 80       	push   $0x801071a1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 5a 61 00 00       	call   80106d50 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 0e 3a 00 00       	call   80104640 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 fb 39 00 00       	call   80104640 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 6a 62 00 00       	call   80106ec0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 00 62 00 00       	call   80106ec0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 fb 38 00 00       	call   80104600 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 7f 5b 00 00       	call   801068b0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 f7 5e 00 00       	call   80106c30 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 ad 71 10 80       	push   $0x801071ad
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 3b 34 00 00       	call   801041a0 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 7a 35 00 00       	call   80104300 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 fa 35 00 00       	call   801043b0 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 e3 35 00 00       	call   801043b0 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 0c 35 00 00       	call   80104300 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 9f 35 00 00       	call   801043b0 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 b4 71 10 80       	push   $0x801071b4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 ba 34 00 00       	call   80104300 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 3f 35 00 00       	jmp    801043b0 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 13 35 00 00       	call   801043b0 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 1a 24 00 00       	call   801032e0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 6b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 b0 08 00 00       	call   80101790 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 c1 1c 00 00       	jmp    80102bb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 bc 71 10 80       	push   $0x801071bc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 46 07 00 00       	call   80101660 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 e9 09 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 10 08 00 00       	call   80101740 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 e1 06 00 00       	call   80101660 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 b4 09 00 00       	call   80101940 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 9d 07 00 00       	call   80101740 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 be 24 00 00       	jmp    80103480 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 c6 71 10 80       	push   $0x801071c6
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 07 07 00 00       	call   80101740 <iunlock>
      end_op();
80101039:	e8 72 1b 00 00       	call   80102bb0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 d5 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 ea 05 00 00       	call   80101660 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 b8 09 00 00       	call   80101a40 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 a3 06 00 00       	call   80101740 <iunlock>
      end_op();
8010109d:	e8 0e 1b 00 00       	call   80102bb0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 9f 22 00 00       	jmp    80103380 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 cf 71 10 80       	push   $0x801071cf
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 d5 71 10 80       	push   $0x801071d5
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	56                   	push   %esi
80101104:	53                   	push   %ebx
80101105:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101107:	c1 ea 0c             	shr    $0xc,%edx
8010110a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101110:	83 ec 08             	sub    $0x8,%esp
80101113:	52                   	push   %edx
80101114:	50                   	push   %eax
80101115:	e8 b6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010111a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010111c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
80101127:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112a:	c1 fb 03             	sar    $0x3,%ebx
8010112d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101130:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101132:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101137:	85 d1                	test   %edx,%ecx
80101139:	74 27                	je     80101162 <bfree+0x62>
8010113b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010113d:	f7 d2                	not    %edx
8010113f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101141:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101144:	21 d0                	and    %edx,%eax
80101146:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010114a:	56                   	push   %esi
8010114b:	e8 d0 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101150:	89 34 24             	mov    %esi,(%esp)
80101153:	e8 88 f0 ff ff       	call   801001e0 <brelse>
}
80101158:	83 c4 10             	add    $0x10,%esp
8010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010115e:	5b                   	pop    %ebx
8010115f:	5e                   	pop    %esi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 df 71 10 80       	push   $0x801071df
8010116a:	e8 01 f2 ff ff       	call   80100370 <panic>
8010116f:	90                   	nop

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 85 00 00 00    	je     8010120f <balloc+0x9f>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ae:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2d                	jmp    801011ea <balloc+0x7a>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
801011c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011d9:	85 d7                	test   %edx,%edi
801011db:	74 43                	je     80101220 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011dd:	83 c0 01             	add    $0x1,%eax
801011e0:	83 c6 01             	add    $0x1,%esi
801011e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011e8:	74 05                	je     801011ef <balloc+0x7f>
801011ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ed:	72 d1                	jb     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101207:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120d:	77 82                	ja     80101191 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	68 f2 71 10 80       	push   $0x801071f2
80101217:	e8 54 f1 ff ff       	call   80100370 <panic>
8010121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	09 fa                	or     %edi,%edx
80101222:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101225:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 ee 1a 00 00       	call   80102d20 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 a6 31 00 00       	call   80104400 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 be 1a 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101295:	68 e0 09 11 80       	push   $0x801109e0
8010129a:	e8 61 30 00 00       	call   80104300 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 1b                	jmp    801012c2 <iget+0x42>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 44                	je     801012f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ba:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012c0:	74 4e                	je     80101310 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c5:	85 c9                	test   %ecx,%ecx
801012c7:	7e e7                	jle    801012b0 <iget+0x30>
801012c9:	39 3b                	cmp    %edi,(%ebx)
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012d0:	75 de                	jne    801012b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012da:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012e2:	e8 c9 30 00 00       	call   801043b0 <release>
      return ip;
801012e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 c9                	test   %ecx,%ecx
801012fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fd:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101303:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101309:	75 b7                	jne    801012c2 <iget+0x42>
8010130b:	90                   	nop
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 2d                	je     80101341 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 e0 09 11 80       	push   $0x801109e0
8010132f:	e8 7c 30 00 00       	call   801043b0 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 08 72 10 80       	push   $0x80107208
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010135b:	83 fa 0b             	cmp    $0xb,%edx
8010135e:	77 18                	ja     80101378 <bmap+0x28>
80101360:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	74 76                	je     801013e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101378:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010137b:	83 fb 7f             	cmp    $0x7f,%ebx
8010137e:	0f 87 83 00 00 00    	ja     80101407 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101384:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010138a:	85 c0                	test   %eax,%eax
8010138c:	74 6a                	je     801013f8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138e:	83 ec 08             	sub    $0x8,%esp
80101391:	50                   	push   %eax
80101392:	ff 36                	pushl  (%esi)
80101394:	e8 37 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101399:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010139d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013a0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a2:	8b 1a                	mov    (%edx),%ebx
801013a4:	85 db                	test   %ebx,%ebx
801013a6:	75 1d                	jne    801013c5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ad:	e8 be fd ff ff       	call   80101170 <balloc>
801013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013b8:	89 c3                	mov    %eax,%ebx
801013ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 5e 19 00 00       	call   80102d20 <log_write>
801013c2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	57                   	push   %edi
801013c9:	e8 12 ee ff ff       	call   801001e0 <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    
801013db:	90                   	nop
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	e8 89 fd ff ff       	call   80101170 <balloc>
801013e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 06                	mov    (%esi),%eax
801013fa:	e8 71 fd ff ff       	call   80101170 <balloc>
801013ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101405:	eb 87                	jmp    8010138e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	68 18 72 10 80       	push   $0x80107218
8010140f:	e8 5c ef ff ff       	call   80100370 <panic>
80101414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010141a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	83 ec 08             	sub    $0x8,%esp
8010142b:	6a 01                	push   $0x1
8010142d:	ff 75 08             	pushl  0x8(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
80101435:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101437:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143a:	83 c4 0c             	add    $0xc,%esp
8010143d:	6a 1c                	push   $0x1c
8010143f:	50                   	push   %eax
80101440:	56                   	push   %esi
80101441:	e8 6a 30 00 00       	call   801044b0 <memmove>
  brelse(bp);
80101446:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101449:	83 c4 10             	add    $0x10,%esp
}
8010144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101452:	e9 89 ed ff ff       	jmp    801001e0 <brelse>
80101457:	89 f6                	mov    %esi,%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	68 2b 72 10 80       	push   $0x8010722b
80101471:	68 e0 09 11 80       	push   $0x801109e0
80101476:	e8 25 2d 00 00       	call   801041a0 <initlock>
8010147b:	83 c4 10             	add    $0x10,%esp
8010147e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	68 32 72 10 80       	push   $0x80107232
80101488:	53                   	push   %ebx
80101489:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148f:	e8 dc 2b 00 00       	call   80104070 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149d:	75 e1                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149f:	83 ec 08             	sub    $0x8,%esp
801014a2:	68 c0 09 11 80       	push   $0x801109c0
801014a7:	ff 75 08             	pushl  0x8(%ebp)
801014aa:	e8 71 ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014af:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014b5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014bb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014c1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014c7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014cd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014d3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014d9:	68 98 72 10 80       	push   $0x80107298
801014de:	e8 7d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014e3:	83 c4 30             	add    $0x30,%esp
801014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e9:	c9                   	leave  
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014f0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	8b 75 08             	mov    0x8(%ebp),%esi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 91 00 00 00    	jbe    801015a0 <ialloc+0xb0>
8010150f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101514:	eb 21                	jmp    80101537 <ialloc+0x47>
80101516:	8d 76 00             	lea    0x0(%esi),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101520:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101526:	57                   	push   %edi
80101527:	e8 b4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101535:	76 69                	jbe    801015a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101537:	89 d8                	mov    %ebx,%eax
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	c1 e8 03             	shr    $0x3,%eax
8010153f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101545:	50                   	push   %eax
80101546:	56                   	push   %esi
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101550:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101553:	83 e0 07             	and    $0x7,%eax
80101556:	c1 e0 06             	shl    $0x6,%eax
80101559:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101561:	75 bd                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101563:	83 ec 04             	sub    $0x4,%esp
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	6a 40                	push   $0x40
8010156b:	6a 00                	push   $0x0
8010156d:	51                   	push   %ecx
8010156e:	e8 8d 2e 00 00       	call   80104400 <memset>
      dip->type = type;
80101573:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101577:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010157a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010157d:	89 3c 24             	mov    %edi,(%esp)
80101580:	e8 9b 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
80101585:	89 3c 24             	mov    %edi,(%esp)
80101588:	e8 53 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010158d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101593:	89 da                	mov    %ebx,%edx
80101595:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101597:	5b                   	pop    %ebx
80101598:	5e                   	pop    %esi
80101599:	5f                   	pop    %edi
8010159a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010159b:	e9 e0 fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015a0:	83 ec 0c             	sub    $0xc,%esp
801015a3:	68 38 72 10 80       	push   $0x80107238
801015a8:	e8 c3 ed ff ff       	call   80100370 <panic>
801015ad:	8d 76 00             	lea    0x0(%esi),%esi

801015b0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c1:	c1 e8 03             	shr    $0x3,%eax
801015c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ca:	50                   	push   %eax
801015cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ce:	e8 fd ea ff ff       	call   801000d0 <bread>
801015d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015df:	83 e0 07             	and    $0x7,%eax
801015e2:	c1 e0 06             	shl    $0x6,%eax
801015e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101603:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101607:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010160a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160d:	6a 34                	push   $0x34
8010160f:	53                   	push   %ebx
80101610:	50                   	push   %eax
80101611:	e8 9a 2e 00 00       	call   801044b0 <memmove>
  log_write(bp);
80101616:	89 34 24             	mov    %esi,(%esp)
80101619:	e8 02 17 00 00       	call   80102d20 <log_write>
  brelse(bp);
8010161e:	89 75 08             	mov    %esi,0x8(%ebp)
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010162a:	e9 b1 eb ff ff       	jmp    801001e0 <brelse>
8010162f:	90                   	nop

80101630 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	83 ec 10             	sub    $0x10,%esp
80101637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010163a:	68 e0 09 11 80       	push   $0x801109e0
8010163f:	e8 bc 2c 00 00       	call   80104300 <acquire>
  ip->ref++;
80101644:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101648:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010164f:	e8 5c 2d 00 00       	call   801043b0 <release>
  return ip;
}
80101654:	89 d8                	mov    %ebx,%eax
80101656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101659:	c9                   	leave  
8010165a:	c3                   	ret    
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101668:	85 db                	test   %ebx,%ebx
8010166a:	0f 84 b7 00 00 00    	je     80101727 <ilock+0xc7>
80101670:	8b 53 08             	mov    0x8(%ebx),%edx
80101673:	85 d2                	test   %edx,%edx
80101675:	0f 8e ac 00 00 00    	jle    80101727 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010167b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	50                   	push   %eax
80101682:	e8 29 2a 00 00       	call   801040b0 <acquiresleep>

  if(ip->valid == 0){
80101687:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010168a:	83 c4 10             	add    $0x10,%esp
8010168d:	85 c0                	test   %eax,%eax
8010168f:	74 0f                	je     801016a0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101691:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101694:	5b                   	pop    %ebx
80101695:	5e                   	pop    %esi
80101696:	5d                   	pop    %ebp
80101697:	c3                   	ret    
80101698:	90                   	nop
80101699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a0:	8b 43 04             	mov    0x4(%ebx),%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	c1 e8 03             	shr    $0x3,%eax
801016a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016af:	50                   	push   %eax
801016b0:	ff 33                	pushl  (%ebx)
801016b2:	e8 19 ea ff ff       	call   801000d0 <bread>
801016b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016c9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016f1:	6a 34                	push   $0x34
801016f3:	50                   	push   %eax
801016f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016f7:	50                   	push   %eax
801016f8:	e8 b3 2d 00 00       	call   801044b0 <memmove>
    brelse(bp);
801016fd:	89 34 24             	mov    %esi,(%esp)
80101700:	e8 db ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010170d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101714:	0f 85 77 ff ff ff    	jne    80101691 <ilock+0x31>
      panic("ilock: no type");
8010171a:	83 ec 0c             	sub    $0xc,%esp
8010171d:	68 50 72 10 80       	push   $0x80107250
80101722:	e8 49 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	68 4a 72 10 80       	push   $0x8010724a
8010172f:	e8 3c ec ff ff       	call   80100370 <panic>
80101734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010173a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101740 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	74 28                	je     80101774 <iunlock+0x34>
8010174c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010174f:	83 ec 0c             	sub    $0xc,%esp
80101752:	56                   	push   %esi
80101753:	e8 f8 29 00 00       	call   80104150 <holdingsleep>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	85 c0                	test   %eax,%eax
8010175d:	74 15                	je     80101774 <iunlock+0x34>
8010175f:	8b 43 08             	mov    0x8(%ebx),%eax
80101762:	85 c0                	test   %eax,%eax
80101764:	7e 0e                	jle    80101774 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101766:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101769:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010176f:	e9 9c 29 00 00       	jmp    80104110 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	68 5f 72 10 80       	push   $0x8010725f
8010177c:	e8 ef eb ff ff       	call   80100370 <panic>
80101781:	eb 0d                	jmp    80101790 <iput>
80101783:	90                   	nop
80101784:	90                   	nop
80101785:	90                   	nop
80101786:	90                   	nop
80101787:	90                   	nop
80101788:	90                   	nop
80101789:	90                   	nop
8010178a:	90                   	nop
8010178b:	90                   	nop
8010178c:	90                   	nop
8010178d:	90                   	nop
8010178e:	90                   	nop
8010178f:	90                   	nop

80101790 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 28             	sub    $0x28,%esp
80101799:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010179c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010179f:	57                   	push   %edi
801017a0:	e8 0b 29 00 00       	call   801040b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017a5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 d2                	test   %edx,%edx
801017ad:	74 07                	je     801017b6 <iput+0x26>
801017af:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017b4:	74 32                	je     801017e8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017b6:	83 ec 0c             	sub    $0xc,%esp
801017b9:	57                   	push   %edi
801017ba:	e8 51 29 00 00       	call   80104110 <releasesleep>

  acquire(&icache.lock);
801017bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017c6:	e8 35 2b 00 00       	call   80104300 <acquire>
  ip->ref--;
801017cb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017dc:	5b                   	pop    %ebx
801017dd:	5e                   	pop    %esi
801017de:	5f                   	pop    %edi
801017df:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017e0:	e9 cb 2b 00 00       	jmp    801043b0 <release>
801017e5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 e0 09 11 80       	push   $0x801109e0
801017f0:	e8 0b 2b 00 00       	call   80104300 <acquire>
    int r = ip->ref;
801017f5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017f8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017ff:	e8 ac 2b 00 00       	call   801043b0 <release>
    if(r == 1){
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	83 fb 01             	cmp    $0x1,%ebx
8010180a:	75 aa                	jne    801017b6 <iput+0x26>
8010180c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101812:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101815:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101818:	89 cf                	mov    %ecx,%edi
8010181a:	eb 0b                	jmp    80101827 <iput+0x97>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0xb0>
    if(ip->addrs[i]){
80101827:	8b 13                	mov    (%ebx),%edx
80101829:	85 d2                	test   %edx,%edx
8010182b:	74 f3                	je     80101820 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010182d:	8b 06                	mov    (%esi),%eax
8010182f:	e8 cc f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101834:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010183a:	eb e4                	jmp    80101820 <iput+0x90>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101849:	85 c0                	test   %eax,%eax
8010184b:	75 33                	jne    80101880 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010184d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101850:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101857:	56                   	push   %esi
80101858:	e8 53 fd ff ff       	call   801015b0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010185d:	31 c0                	xor    %eax,%eax
8010185f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101863:	89 34 24             	mov    %esi,(%esp)
80101866:	e8 45 fd ff ff       	call   801015b0 <iupdate>
      ip->valid = 0;
8010186b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101872:	83 c4 10             	add    $0x10,%esp
80101875:	e9 3c ff ff ff       	jmp    801017b6 <iput+0x26>
8010187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	50                   	push   %eax
80101884:	ff 36                	pushl  (%esi)
80101886:	e8 45 e8 ff ff       	call   801000d0 <bread>
8010188b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101891:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101897:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	89 cf                	mov    %ecx,%edi
8010189f:	eb 0e                	jmp    801018af <iput+0x11f>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018ab:	39 fb                	cmp    %edi,%ebx
801018ad:	74 0f                	je     801018be <iput+0x12e>
      if(a[j])
801018af:	8b 13                	mov    (%ebx),%edx
801018b1:	85 d2                	test   %edx,%edx
801018b3:	74 f3                	je     801018a8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018b5:	8b 06                	mov    (%esi),%eax
801018b7:	e8 44 f8 ff ff       	call   80101100 <bfree>
801018bc:	eb ea                	jmp    801018a8 <iput+0x118>
    }
    brelse(bp);
801018be:	83 ec 0c             	sub    $0xc,%esp
801018c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018c7:	e8 14 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018cc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d2:	8b 06                	mov    (%esi),%eax
801018d4:	e8 27 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
801018d9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e0:	00 00 00 
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	e9 62 ff ff ff       	jmp    8010184d <iput+0xbd>
801018eb:	90                   	nop
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	53                   	push   %ebx
801018fb:	e8 40 fe ff ff       	call   80101740 <iunlock>
  iput(ip);
80101900:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101903:	83 c4 10             	add    $0x10,%esp
}
80101906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101909:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 81 fe ff ff       	jmp    80101790 <iput>
8010190f:	90                   	nop

80101910 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 1c             	sub    $0x1c,%esp
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101952:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101957:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010195d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101960:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101963:	0f 84 a7 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101969:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010196c:	8b 40 58             	mov    0x58(%eax),%eax
8010196f:	39 f0                	cmp    %esi,%eax
80101971:	0f 82 c1 00 00 00    	jb     80101a38 <readi+0xf8>
80101977:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010197a:	89 fa                	mov    %edi,%edx
8010197c:	01 f2                	add    %esi,%edx
8010197e:	0f 82 b4 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101984:	89 c1                	mov    %eax,%ecx
80101986:	29 f1                	sub    %esi,%ecx
80101988:	39 d0                	cmp    %edx,%eax
8010198a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198d:	31 ff                	xor    %edi,%edi
8010198f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101991:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101994:	74 6d                	je     80101a03 <readi+0xc3>
80101996:	8d 76 00             	lea    0x0(%esi),%esi
80101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019a3:	89 f2                	mov    %esi,%edx
801019a5:	c1 ea 09             	shr    $0x9,%edx
801019a8:	89 d8                	mov    %ebx,%eax
801019aa:	e8 a1 f9 ff ff       	call   80101350 <bmap>
801019af:	83 ec 08             	sub    $0x8,%esp
801019b2:	50                   	push   %eax
801019b3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019b5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ba:	e8 11 e7 ff ff       	call   801000d0 <bread>
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019c4:	89 f1                	mov    %esi,%ecx
801019c6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019cc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d2:	29 cb                	sub    %ecx,%ebx
801019d4:	29 f8                	sub    %edi,%eax
801019d6:	39 c3                	cmp    %eax,%ebx
801019d8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019db:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019df:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e0:	01 df                	add    %ebx,%edi
801019e2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019e4:	50                   	push   %eax
801019e5:	ff 75 e0             	pushl  -0x20(%ebp)
801019e8:	e8 c3 2a 00 00       	call   801044b0 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a01:	77 9d                	ja     801019a0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a09:	5b                   	pop    %ebx
80101a0a:	5e                   	pop    %esi
80101a0b:	5f                   	pop    %edi
80101a0c:	5d                   	pop    %ebp
80101a0d:	c3                   	ret    
80101a0e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2b:	5b                   	pop    %ebx
80101a2c:	5e                   	pop    %esi
80101a2d:	5f                   	pop    %edi
80101a2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a2f:	ff e0                	jmp    *%eax
80101a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c7                	jmp    80101a06 <readi+0xc6>
80101a3f:	90                   	nop

80101a40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 eb 00 00 00    	jb     80101b60 <writei+0x120>
80101a75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a78:	89 f8                	mov    %edi,%eax
80101a7a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a7c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a81:	0f 87 d9 00 00 00    	ja     80101b60 <writei+0x120>
80101a87:	39 c6                	cmp    %eax,%esi
80101a89:	0f 87 d1 00 00 00    	ja     80101b60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8f:	85 ff                	test   %edi,%edi
80101a91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a98:	74 78                	je     80101b12 <writei+0xd2>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aa3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aaa:	c1 ea 09             	shr    $0x9,%edx
80101aad:	89 f8                	mov    %edi,%eax
80101aaf:	e8 9c f8 ff ff       	call   80101350 <bmap>
80101ab4:	83 ec 08             	sub    $0x8,%esp
80101ab7:	50                   	push   %eax
80101ab8:	ff 37                	pushl  (%edi)
80101aba:	e8 11 e6 ff ff       	call   801000d0 <bread>
80101abf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ac4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ac7:	89 f1                	mov    %esi,%ecx
80101ac9:	83 c4 0c             	add    $0xc,%esp
80101acc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ad2:	29 cb                	sub    %ecx,%ebx
80101ad4:	39 c3                	cmp    %eax,%ebx
80101ad6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101add:	53                   	push   %ebx
80101ade:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	50                   	push   %eax
80101ae4:	e8 c7 29 00 00       	call   801044b0 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b05:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b08:	77 96                	ja     80101aa0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b10:	77 36                	ja     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b18:	5b                   	pop    %ebx
80101b19:	5e                   	pop    %esi
80101b1a:	5f                   	pop    %edi
80101b1b:	5d                   	pop    %ebp
80101b1c:	c3                   	ret    
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 36                	ja     80101b60 <writei+0x120>
80101b2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 2b                	je     80101b60 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b51:	50                   	push   %eax
80101b52:	e8 59 fa ff ff       	call   801015b0 <iupdate>
80101b57:	83 c4 10             	add    $0x10,%esp
80101b5a:	eb b6                	jmp    80101b12 <writei+0xd2>
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b65:	eb ae                	jmp    80101b15 <writei+0xd5>
80101b67:	89 f6                	mov    %esi,%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	6a 0e                	push   $0xe
80101b78:	ff 75 0c             	pushl  0xc(%ebp)
80101b7b:	ff 75 08             	pushl  0x8(%ebp)
80101b7e:	e8 ad 29 00 00       	call   80104530 <strncmp>
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ba1:	0f 85 80 00 00 00    	jne    80101c27 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8b 53 58             	mov    0x58(%ebx),%edx
80101baa:	31 ff                	xor    %edi,%edi
80101bac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101baf:	85 d2                	test   %edx,%edx
80101bb1:	75 0d                	jne    80101bc0 <dirlookup+0x30>
80101bb3:	eb 5b                	jmp    80101c10 <dirlookup+0x80>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
80101bb8:	83 c7 10             	add    $0x10,%edi
80101bbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bbe:	76 50                	jbe    80101c10 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc0:	6a 10                	push   $0x10
80101bc2:	57                   	push   %edi
80101bc3:	56                   	push   %esi
80101bc4:	53                   	push   %ebx
80101bc5:	e8 76 fd ff ff       	call   80101940 <readi>
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	83 f8 10             	cmp    $0x10,%eax
80101bd0:	75 48                	jne    80101c1a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd7:	74 df                	je     80101bb8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bd9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bdc:	83 ec 04             	sub    $0x4,%esp
80101bdf:	6a 0e                	push   $0xe
80101be1:	50                   	push   %eax
80101be2:	ff 75 0c             	pushl  0xc(%ebp)
80101be5:	e8 46 29 00 00       	call   80104530 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	85 c0                	test   %eax,%eax
80101bef:	75 c7                	jne    80101bb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bf1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	74 05                	je     80101bfd <dirlookup+0x6d>
        *poff = off;
80101bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bfd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c01:	8b 03                	mov    (%ebx),%eax
80101c03:	e8 78 f6 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
80101c0f:	c3                   	ret    
80101c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c13:	31 c0                	xor    %eax,%eax
}
80101c15:	5b                   	pop    %ebx
80101c16:	5e                   	pop    %esi
80101c17:	5f                   	pop    %edi
80101c18:	5d                   	pop    %ebp
80101c19:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c1a:	83 ec 0c             	sub    $0xc,%esp
80101c1d:	68 79 72 10 80       	push   $0x80107279
80101c22:	e8 49 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 67 72 10 80       	push   $0x80107267
80101c2f:	e8 3c e7 ff ff       	call   80100370 <panic>
80101c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	89 cf                	mov    %ecx,%edi
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c4d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c53:	0f 84 5b 01 00 00    	je     80101db4 <namex+0x174>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c59:	e8 02 1b 00 00       	call   80103760 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c61:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c64:	68 e0 09 11 80       	push   $0x801109e0
80101c69:	e8 92 26 00 00       	call   80104300 <acquire>
  ip->ref++;
80101c6e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c72:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c79:	e8 32 27 00 00       	call   801043b0 <release>
80101c7e:	83 c4 10             	add    $0x10,%esp
80101c81:	eb 08                	jmp    80101c8b <namex+0x4b>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c88:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c8b:	0f b6 03             	movzbl (%ebx),%eax
80101c8e:	3c 2f                	cmp    $0x2f,%al
80101c90:	74 f6                	je     80101c88 <namex+0x48>
    path++;
  if(*path == 0)
80101c92:	84 c0                	test   %al,%al
80101c94:	0f 84 eb 00 00 00    	je     80101d85 <namex+0x145>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c9a:	0f b6 03             	movzbl (%ebx),%eax
80101c9d:	89 da                	mov    %ebx,%edx
80101c9f:	3c 2f                	cmp    $0x2f,%al
80101ca1:	0f 84 b4 00 00 00    	je     80101d5b <namex+0x11b>
80101ca7:	84 c0                	test   %al,%al
80101ca9:	75 09                	jne    80101cb4 <namex+0x74>
80101cab:	e9 ab 00 00 00       	jmp    80101d5b <namex+0x11b>
80101cb0:	84 c0                	test   %al,%al
80101cb2:	74 0a                	je     80101cbe <namex+0x7e>
    path++;
80101cb4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb7:	0f b6 02             	movzbl (%edx),%eax
80101cba:	3c 2f                	cmp    $0x2f,%al
80101cbc:	75 f2                	jne    80101cb0 <namex+0x70>
80101cbe:	89 d1                	mov    %edx,%ecx
80101cc0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cc2:	83 f9 0d             	cmp    $0xd,%ecx
80101cc5:	0f 8e 95 00 00 00    	jle    80101d60 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101ccb:	83 ec 04             	sub    $0x4,%esp
80101cce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cd1:	6a 0e                	push   $0xe
80101cd3:	53                   	push   %ebx
80101cd4:	57                   	push   %edi
80101cd5:	e8 d6 27 00 00       	call   801044b0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cdd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ce0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce5:	75 11                	jne    80101cf8 <namex+0xb8>
80101ce7:	89 f6                	mov    %esi,%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xb0>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80101cf8:	85 db                	test   %ebx,%ebx
80101cfa:	0f 84 85 00 00 00    	je     80101d85 <namex+0x145>
    ilock(ip);
80101d00:	83 ec 0c             	sub    $0xc,%esp
80101d03:	56                   	push   %esi
80101d04:	e8 57 f9 ff ff       	call   80101660 <ilock>
    if(ip->type != T_DIR){
80101d09:	83 c4 10             	add    $0x10,%esp
80101d0c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d11:	0f 85 7f 00 00 00    	jne    80101d96 <namex+0x156>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d17:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d1a:	85 d2                	test   %edx,%edx
80101d1c:	74 09                	je     80101d27 <namex+0xe7>
80101d1e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d21:	0f 84 a3 00 00 00    	je     80101dca <namex+0x18a>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d27:	83 ec 04             	sub    $0x4,%esp
80101d2a:	6a 00                	push   $0x0
80101d2c:	57                   	push   %edi
80101d2d:	56                   	push   %esi
80101d2e:	e8 5d fe ff ff       	call   80101b90 <dirlookup>
80101d33:	83 c4 10             	add    $0x10,%esp
80101d36:	85 c0                	test   %eax,%eax
80101d38:	74 5c                	je     80101d96 <namex+0x156>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d3a:	83 ec 0c             	sub    $0xc,%esp
80101d3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d40:	56                   	push   %esi
80101d41:	e8 fa f9 ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d46:	89 34 24             	mov    %esi,(%esp)
80101d49:	e8 42 fa ff ff       	call   80101790 <iput>
80101d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	89 c6                	mov    %eax,%esi
80101d56:	e9 30 ff ff ff       	jmp    80101c8b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d5b:	31 c9                	xor    %ecx,%ecx
80101d5d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d60:	83 ec 04             	sub    $0x4,%esp
80101d63:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d66:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d69:	51                   	push   %ecx
80101d6a:	53                   	push   %ebx
80101d6b:	57                   	push   %edi
80101d6c:	e8 3f 27 00 00       	call   801044b0 <memmove>
    name[len] = 0;
80101d71:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d77:	83 c4 10             	add    $0x10,%esp
80101d7a:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d7e:	89 d3                	mov    %edx,%ebx
80101d80:	e9 5d ff ff ff       	jmp    80101ce2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d88:	85 c0                	test   %eax,%eax
80101d8a:	75 54                	jne    80101de0 <namex+0x1a0>
80101d8c:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d91:	5b                   	pop    %ebx
80101d92:	5e                   	pop    %esi
80101d93:	5f                   	pop    %edi
80101d94:	5d                   	pop    %ebp
80101d95:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d96:	83 ec 0c             	sub    $0xc,%esp
80101d99:	56                   	push   %esi
80101d9a:	e8 a1 f9 ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d9f:	89 34 24             	mov    %esi,(%esp)
80101da2:	e8 e9 f9 ff ff       	call   80101790 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101da7:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dad:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	5b                   	pop    %ebx
80101db0:	5e                   	pop    %esi
80101db1:	5f                   	pop    %edi
80101db2:	5d                   	pop    %ebp
80101db3:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101db4:	ba 01 00 00 00       	mov    $0x1,%edx
80101db9:	b8 01 00 00 00       	mov    $0x1,%eax
80101dbe:	e8 bd f4 ff ff       	call   80101280 <iget>
80101dc3:	89 c6                	mov    %eax,%esi
80101dc5:	e9 c1 fe ff ff       	jmp    80101c8b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dca:	83 ec 0c             	sub    $0xc,%esp
80101dcd:	56                   	push   %esi
80101dce:	e8 6d f9 ff ff       	call   80101740 <iunlock>
      return ip;
80101dd3:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dd9:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	56                   	push   %esi
80101de4:	e8 a7 f9 ff ff       	call   80101790 <iput>
    return 0;
80101de9:	83 c4 10             	add    $0x10,%esp
80101dec:	31 c0                	xor    %eax,%eax
80101dee:	eb 9e                	jmp    80101d8e <namex+0x14e>

80101df0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 89 fd ff ff       	call   80101b90 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e26:	76 19                	jbe    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 0e fb ff ff       	call   80101940 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 4e 27 00 00       	call   801045a0 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 dd fb ff ff       	call   80101a40 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 12 f9 ff ff       	call   80101790 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 88 72 10 80       	push   $0x80107288
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 86 78 10 80       	push   $0x80107886
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 7d fd ff ff       	call   80101c40 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101edf:	e9 5c fd ff ff       	jmp    80101c40 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
  if(b == 0)
80101ef1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	56                   	push   %esi
80101ef6:	53                   	push   %ebx
  if(b == 0)
80101ef7:	0f 84 ad 00 00 00    	je     80101faa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101efd:	8b 58 08             	mov    0x8(%eax),%ebx
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f08:	0f 87 8f 00 00 00    	ja     80101f9d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f13:	90                   	nop
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f18:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f19:	83 e0 c0             	and    $0xffffffc0,%eax
80101f1c:	3c 40                	cmp    $0x40,%al
80101f1e:	75 f8                	jne    80101f18 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f20:	31 f6                	xor    %esi,%esi
80101f22:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f27:	89 f0                	mov    %esi,%eax
80101f29:	ee                   	out    %al,(%dx)
80101f2a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f34:	ee                   	out    %al,(%dx)
80101f35:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f3a:	89 d8                	mov    %ebx,%eax
80101f3c:	ee                   	out    %al,(%dx)
80101f3d:	89 d8                	mov    %ebx,%eax
80101f3f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f44:	c1 f8 08             	sar    $0x8,%eax
80101f47:	ee                   	out    %al,(%dx)
80101f48:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f4d:	89 f0                	mov    %esi,%eax
80101f4f:	ee                   	out    %al,(%dx)
80101f50:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	83 e0 01             	and    $0x1,%eax
80101f5c:	c1 e0 04             	shl    $0x4,%eax
80101f5f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f62:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f63:	f6 01 04             	testb  $0x4,(%ecx)
80101f66:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f6b:	75 13                	jne    80101f80 <idestart+0x90>
80101f6d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f72:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f80:	b8 30 00 00 00       	mov    $0x30,%eax
80101f85:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f86:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f8b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f8e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f93:	fc                   	cld    
80101f94:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5d                   	pop    %ebp
80101f9c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f9d:	83 ec 0c             	sub    $0xc,%esp
80101fa0:	68 f4 72 10 80       	push   $0x801072f4
80101fa5:	e8 c6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 eb 72 10 80       	push   $0x801072eb
80101fb2:	e8 b9 e3 ff ff       	call   80100370 <panic>
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fc6:	68 06 73 10 80       	push   $0x80107306
80101fcb:	68 80 a5 10 80       	push   $0x8010a580
80101fd0:	e8 cb 21 00 00       	call   801041a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fd5:	58                   	pop    %eax
80101fd6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fdb:	5a                   	pop    %edx
80101fdc:	83 e8 01             	sub    $0x1,%eax
80101fdf:	50                   	push   %eax
80101fe0:	6a 0e                	push   $0xe
80101fe2:	e8 a9 02 00 00       	call   80102290 <ioapicenable>
80101fe7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fef:	90                   	nop
80101ff0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff1:	83 e0 c0             	and    $0xffffffc0,%eax
80101ff4:	3c 40                	cmp    $0x40,%al
80101ff6:	75 f8                	jne    80101ff0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ff8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ffd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102002:	ee                   	out    %al,(%dx)
80102003:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102008:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200d:	eb 06                	jmp    80102015 <ideinit+0x55>
8010200f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102010:	83 e9 01             	sub    $0x1,%ecx
80102013:	74 0f                	je     80102024 <ideinit+0x64>
80102015:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102016:	84 c0                	test   %al,%al
80102018:	74 f6                	je     80102010 <ideinit+0x50>
      havedisk1 = 1;
8010201a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102021:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102024:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102029:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010202e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010202f:	c9                   	leave  
80102030:	c3                   	ret    
80102031:	eb 0d                	jmp    80102040 <ideintr>
80102033:	90                   	nop
80102034:	90                   	nop
80102035:	90                   	nop
80102036:	90                   	nop
80102037:	90                   	nop
80102038:	90                   	nop
80102039:	90                   	nop
8010203a:	90                   	nop
8010203b:	90                   	nop
8010203c:	90                   	nop
8010203d:	90                   	nop
8010203e:	90                   	nop
8010203f:	90                   	nop

80102040 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102049:	68 80 a5 10 80       	push   $0x8010a580
8010204e:	e8 ad 22 00 00       	call   80104300 <acquire>

  if((b = idequeue) == 0){
80102053:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102059:	83 c4 10             	add    $0x10,%esp
8010205c:	85 db                	test   %ebx,%ebx
8010205e:	74 34                	je     80102094 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102060:	8b 43 58             	mov    0x58(%ebx),%eax
80102063:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102068:	8b 33                	mov    (%ebx),%esi
8010206a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102070:	74 3e                	je     801020b0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102072:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102075:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102078:	83 ce 02             	or     $0x2,%esi
8010207b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010207d:	53                   	push   %ebx
8010207e:	e8 3d 1e 00 00       	call   80103ec0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102083:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 05                	je     80102094 <ideintr+0x54>
    idestart(idequeue);
8010208f:	e8 5c fe ff ff       	call   80101ef0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102094:	83 ec 0c             	sub    $0xc,%esp
80102097:	68 80 a5 10 80       	push   $0x8010a580
8010209c:	e8 0f 23 00 00       	call   801043b0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b5:	8d 76 00             	lea    0x0(%esi),%esi
801020b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b9:	89 c1                	mov    %eax,%ecx
801020bb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020be:	80 f9 40             	cmp    $0x40,%cl
801020c1:	75 f5                	jne    801020b8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020c3:	a8 21                	test   $0x21,%al
801020c5:	75 ab                	jne    80102072 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020c7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ca:	b9 80 00 00 00       	mov    $0x80,%ecx
801020cf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020d4:	fc                   	cld    
801020d5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	eb 97                	jmp    80102072 <ideintr+0x32>
801020db:	90                   	nop
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	53                   	push   %ebx
801020e4:	83 ec 10             	sub    $0x10,%esp
801020e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801020ed:	50                   	push   %eax
801020ee:	e8 5d 20 00 00       	call   80104150 <holdingsleep>
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	85 c0                	test   %eax,%eax
801020f8:	0f 84 ad 00 00 00    	je     801021ab <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020fe:	8b 03                	mov    (%ebx),%eax
80102100:	83 e0 06             	and    $0x6,%eax
80102103:	83 f8 02             	cmp    $0x2,%eax
80102106:	0f 84 b9 00 00 00    	je     801021c5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010210c:	8b 53 04             	mov    0x4(%ebx),%edx
8010210f:	85 d2                	test   %edx,%edx
80102111:	74 0d                	je     80102120 <iderw+0x40>
80102113:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102118:	85 c0                	test   %eax,%eax
8010211a:	0f 84 98 00 00 00    	je     801021b8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102120:	83 ec 0c             	sub    $0xc,%esp
80102123:	68 80 a5 10 80       	push   $0x8010a580
80102128:	e8 d3 21 00 00       	call   80104300 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010212d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102133:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102136:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	85 d2                	test   %edx,%edx
8010213f:	75 09                	jne    8010214a <iderw+0x6a>
80102141:	eb 58                	jmp    8010219b <iderw+0xbb>
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102148:	89 c2                	mov    %eax,%edx
8010214a:	8b 42 58             	mov    0x58(%edx),%eax
8010214d:	85 c0                	test   %eax,%eax
8010214f:	75 f7                	jne    80102148 <iderw+0x68>
80102151:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102154:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102156:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010215c:	74 44                	je     801021a2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	74 23                	je     8010218b <iderw+0xab>
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102170:	83 ec 08             	sub    $0x8,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	53                   	push   %ebx
80102179:	e8 92 1b 00 00       	call   80103d10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	83 e0 06             	and    $0x6,%eax
80102186:	83 f8 02             	cmp    $0x2,%eax
80102189:	75 e5                	jne    80102170 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010218b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102195:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102196:	e9 15 22 00 00       	jmp    801043b0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021a0:	eb b2                	jmp    80102154 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021a2:	89 d8                	mov    %ebx,%eax
801021a4:	e8 47 fd ff ff       	call   80101ef0 <idestart>
801021a9:	eb b3                	jmp    8010215e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021ab:	83 ec 0c             	sub    $0xc,%esp
801021ae:	68 0a 73 10 80       	push   $0x8010730a
801021b3:	e8 b8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 35 73 10 80       	push   $0x80107335
801021c0:	e8 ab e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 20 73 10 80       	push   $0x80107320
801021cd:	e8 9e e1 ff ff       	call   80100370 <panic>
801021d2:	66 90                	xchg   %ax,%ax
801021d4:	66 90                	xchg   %ax,%ax
801021d6:	66 90                	xchg   %ax,%ax
801021d8:	66 90                	xchg   %ax,%ax
801021da:	66 90                	xchg   %ax,%ax
801021dc:	66 90                	xchg   %ax,%ax
801021de:	66 90                	xchg   %ax,%ax

801021e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021e8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021eb:	89 e5                	mov    %esp,%ebp
801021ed:	56                   	push   %esi
801021ee:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021f6:	00 00 00 
  return ioapic->data;
801021f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021ff:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102202:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102208:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102215:	89 f0                	mov    %esi,%eax
80102217:	c1 e8 10             	shr    $0x10,%eax
8010221a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010221d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102220:	c1 e8 18             	shr    $0x18,%eax
80102223:	39 d0                	cmp    %edx,%eax
80102225:	74 16                	je     8010223d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 54 73 10 80       	push   $0x80107354
8010222f:	e8 2c e4 ff ff       	call   80100660 <cprintf>
80102234:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	ba 10 00 00 00       	mov    $0x10,%edx
80102245:	b8 20 00 00 00       	mov    $0x20,%eax
8010224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c3                	mov    %eax,%ebx
8010225a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102260:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102263:	89 59 10             	mov    %ebx,0x10(%ecx)
80102266:	8d 5a 01             	lea    0x1(%edx),%ebx
80102269:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
80102286:	8d 76 00             	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102290:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102291:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102297:	89 e5                	mov    %esp,%ebp
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010229c:	8d 50 20             	lea    0x20(%eax),%edx
8010229f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ae:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b6:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022be:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022c1:	5d                   	pop    %ebp
801022c2:	c3                   	ret    
801022c3:	66 90                	xchg   %ax,%ax
801022c5:	66 90                	xchg   %ax,%ax
801022c7:	66 90                	xchg   %ax,%ax
801022c9:	66 90                	xchg   %ax,%ax
801022cb:	66 90                	xchg   %ax,%ax
801022cd:	66 90                	xchg   %ax,%ax
801022cf:	90                   	nop

801022d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 04             	sub    $0x4,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022e0:	75 70                	jne    80102352 <kfree+0x82>
801022e2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801022e8:	72 68                	jb     80102352 <kfree+0x82>
801022ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022f5:	77 5b                	ja     80102352 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022f7:	83 ec 04             	sub    $0x4,%esp
801022fa:	68 00 10 00 00       	push   $0x1000
801022ff:	6a 01                	push   $0x1
80102301:	53                   	push   %ebx
80102302:	e8 f9 20 00 00       	call   80104400 <memset>

  if(kmem.use_lock)
80102307:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 d2                	test   %edx,%edx
80102312:	75 2c                	jne    80102340 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102314:	a1 78 26 11 80       	mov    0x80112678,%eax
80102319:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010231b:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102320:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102326:	85 c0                	test   %eax,%eax
80102328:	75 06                	jne    80102330 <kfree+0x60>
    release(&kmem.lock);
}
8010232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232d:	c9                   	leave  
8010232e:	c3                   	ret    
8010232f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102330:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010233b:	e9 70 20 00 00       	jmp    801043b0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 40 26 11 80       	push   $0x80112640
80102348:	e8 b3 1f 00 00       	call   80104300 <acquire>
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	eb c2                	jmp    80102314 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 86 73 10 80       	push   $0x80107386
8010235a:	e8 11 e0 ff ff       	call   80100370 <panic>
8010235f:	90                   	nop

80102360 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102365:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102368:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010236b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102371:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102377:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010237d:	39 de                	cmp    %ebx,%esi
8010237f:	72 23                	jb     801023a4 <freerange+0x44>
80102381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102388:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010238e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102391:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102397:	50                   	push   %eax
80102398:	e8 33 ff ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	39 f3                	cmp    %esi,%ebx
801023a2:	76 e4                	jbe    80102388 <freerange+0x28>
    kfree(p);
}
801023a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a7:	5b                   	pop    %ebx
801023a8:	5e                   	pop    %esi
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023b8:	83 ec 08             	sub    $0x8,%esp
801023bb:	68 8c 73 10 80       	push   $0x8010738c
801023c0:	68 40 26 11 80       	push   $0x80112640
801023c5:	e8 d6 1d 00 00       	call   801041a0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023d0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ec:	39 de                	cmp    %ebx,%esi
801023ee:	72 1c                	jb     8010240c <kinit1+0x5c>
    kfree(p);
801023f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ff:	50                   	push   %eax
80102400:	e8 cb fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	39 de                	cmp    %ebx,%esi
8010240a:	73 e4                	jae    801023f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010240f:	5b                   	pop    %ebx
80102410:	5e                   	pop    %esi
80102411:	5d                   	pop    %ebp
80102412:	c3                   	ret    
80102413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <kinit2+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 73 fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 e4                	jae    80102448 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102464:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010246b:	00 00 00 
}
8010246e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102487:	a1 74 26 11 80       	mov    0x80112674,%eax
8010248c:	85 c0                	test   %eax,%eax
8010248e:	75 30                	jne    801024c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102490:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102496:	85 db                	test   %ebx,%ebx
80102498:	74 1c                	je     801024b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010249a:	8b 13                	mov    (%ebx),%edx
8010249c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024a2:	85 c0                	test   %eax,%eax
801024a4:	74 10                	je     801024b6 <kalloc+0x36>
    release(&kmem.lock);
801024a6:	83 ec 0c             	sub    $0xc,%esp
801024a9:	68 40 26 11 80       	push   $0x80112640
801024ae:	e8 fd 1e 00 00       	call   801043b0 <release>
801024b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024b6:	89 d8                	mov    %ebx,%eax
801024b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 40 26 11 80       	push   $0x80112640
801024c8:	e8 33 1e 00 00       	call   80104300 <acquire>
  r = kmem.freelist;
801024cd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024db:	85 db                	test   %ebx,%ebx
801024dd:	75 bb                	jne    8010249a <kalloc+0x1a>
801024df:	eb c1                	jmp    801024a2 <kalloc+0x22>
801024e1:	66 90                	xchg   %ax,%ax
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f1:	ba 64 00 00 00       	mov    $0x64,%edx
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f9:	a8 01                	test   $0x1,%al
801024fb:	0f 84 af 00 00 00    	je     801025b0 <kbdgetc+0xc0>
80102501:	ba 60 00 00 00       	mov    $0x60,%edx
80102506:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102507:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010250a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102510:	74 7e                	je     80102590 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102512:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010251a:	79 24                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010251c:	f6 c1 40             	test   $0x40,%cl
8010251f:	75 05                	jne    80102526 <kbdgetc+0x36>
80102521:	89 c2                	mov    %eax,%edx
80102523:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102526:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
8010252d:	83 c8 40             	or     $0x40,%eax
80102530:	0f b6 c0             	movzbl %al,%eax
80102533:	f7 d0                	not    %eax
80102535:	21 c8                	and    %ecx,%eax
80102537:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010253e:	5d                   	pop    %ebp
8010253f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102540:	f6 c1 40             	test   $0x40,%cl
80102543:	74 09                	je     8010254e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102545:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102548:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010254e:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
80102555:	09 c1                	or     %eax,%ecx
80102557:	0f b6 82 c0 73 10 80 	movzbl -0x7fef8c40(%edx),%eax
8010255e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102560:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102562:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102568:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010256b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010256e:	8b 04 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%eax
80102575:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102579:	74 c3                	je     8010253e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010257b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010257e:	83 fa 19             	cmp    $0x19,%edx
80102581:	77 1d                	ja     801025a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102583:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102586:	5d                   	pop    %ebp
80102587:	c3                   	ret    
80102588:	90                   	nop
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102590:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102592:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	90                   	nop
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025a7:	83 f9 19             	cmp    $0x19,%ecx
801025aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b5:	5d                   	pop    %ebp
801025b6:	c3                   	ret    
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025c6:	68 f0 24 10 80       	push   $0x801024f0
801025cb:	e8 20 e2 ff ff       	call   801007f0 <consoleintr>
}
801025d0:	83 c4 10             	add    $0x10,%esp
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    
801025d5:	66 90                	xchg   %ax,%ax
801025d7:	66 90                	xchg   %ax,%ax
801025d9:	66 90                	xchg   %ax,%ax
801025db:	66 90                	xchg   %ax,%ax
801025dd:	66 90                	xchg   %ax,%ax
801025df:	90                   	nop

801025e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025e5:	55                   	push   %ebp
801025e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025e8:	85 c0                	test   %eax,%eax
801025ea:	0f 84 c8 00 00 00    	je     801026b8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102604:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102607:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102611:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102614:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102617:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010261e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102621:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102624:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010262b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102631:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102638:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010263e:	8b 50 30             	mov    0x30(%eax),%edx
80102641:	c1 ea 10             	shr    $0x10,%edx
80102644:	80 fa 03             	cmp    $0x3,%dl
80102647:	77 77                	ja     801026c0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102649:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102650:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102653:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102656:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102660:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102663:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102677:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102691:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026a6:	80 e6 10             	and    $0x10,%dh
801026a9:	75 f5                	jne    801026a0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	e9 77 ff ff ff       	jmp    80102649 <lapicinit+0x69>
801026d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	74 0c                	je     801026f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026ec:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ef:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026f0:	c1 e8 18             	shr    $0x18,%eax
}
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026f8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026fa:	5d                   	pop    %ebp
801026fb:	c3                   	ret    
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102700:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0d                	je     80102719 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102713:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102716:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
}
80102723:	5d                   	pop    %ebp
80102724:	c3                   	ret    
80102725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102730:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102731:	ba 70 00 00 00       	mov    $0x70,%edx
80102736:	b8 0f 00 00 00       	mov    $0xf,%eax
8010273b:	89 e5                	mov    %esp,%ebp
8010273d:	53                   	push   %ebx
8010273e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102744:	ee                   	out    %al,(%dx)
80102745:	ba 71 00 00 00       	mov    $0x71,%edx
8010274a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010274f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102750:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102752:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102755:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010275b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010275d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102760:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102765:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102768:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102773:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102779:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102783:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102789:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102790:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102796:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010279c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027a5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ba:	5b                   	pop    %ebx
801027bb:	5d                   	pop    %ebp
801027bc:	c3                   	ret    
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027c0:	55                   	push   %ebp
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	57                   	push   %edi
801027ce:	56                   	push   %esi
801027cf:	53                   	push   %ebx
801027d0:	83 ec 4c             	sub    $0x4c,%esp
801027d3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d4:	ba 71 00 00 00       	mov    $0x71,%edx
801027d9:	ec                   	in     (%dx),%al
801027da:	83 e0 04             	and    $0x4,%eax
801027dd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e0:	31 db                	xor    %ebx,%ebx
801027e2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027e5:	bf 70 00 00 00       	mov    $0x70,%edi
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f0:	89 d8                	mov    %ebx,%eax
801027f2:	89 fa                	mov    %edi,%edx
801027f4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027fa:	89 ca                	mov    %ecx,%edx
801027fc:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027fd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102800:	89 fa                	mov    %edi,%edx
80102802:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102805:	b8 02 00 00 00       	mov    $0x2,%eax
8010280a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280b:	89 ca                	mov    %ecx,%edx
8010280d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010280e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102811:	89 fa                	mov    %edi,%edx
80102813:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102816:	b8 04 00 00 00       	mov    $0x4,%eax
8010281b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281c:	89 ca                	mov    %ecx,%edx
8010281e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010281f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102822:	89 fa                	mov    %edi,%edx
80102824:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102827:	b8 07 00 00 00       	mov    $0x7,%eax
8010282c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282d:	89 ca                	mov    %ecx,%edx
8010282f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102830:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102833:	89 fa                	mov    %edi,%edx
80102835:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102838:	b8 08 00 00 00       	mov    $0x8,%eax
8010283d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283e:	89 ca                	mov    %ecx,%edx
80102840:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102841:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102844:	89 fa                	mov    %edi,%edx
80102846:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102849:	b8 09 00 00 00       	mov    $0x9,%eax
8010284e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284f:	89 ca                	mov    %ecx,%edx
80102851:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102852:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102855:	89 fa                	mov    %edi,%edx
80102857:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010285a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010285f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102863:	84 c0                	test   %al,%al
80102865:	78 89                	js     801027f0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102867:	89 d8                	mov    %ebx,%eax
80102869:	89 fa                	mov    %edi,%edx
8010286b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 fa                	mov    %edi,%edx
80102874:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102877:	b8 02 00 00 00       	mov    $0x2,%eax
8010287c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	89 ca                	mov    %ecx,%edx
8010287f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102880:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102883:	89 fa                	mov    %edi,%edx
80102885:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102891:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 fa                	mov    %edi,%edx
80102896:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102899:	b8 07 00 00 00       	mov    $0x7,%eax
8010289e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289f:	89 ca                	mov    %ecx,%edx
801028a1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a5:	89 fa                	mov    %edi,%edx
801028a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028aa:	b8 08 00 00 00       	mov    $0x8,%eax
801028af:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b0:	89 ca                	mov    %ecx,%edx
801028b2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b6:	89 fa                	mov    %edi,%edx
801028b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028bb:	b8 09 00 00 00       	mov    $0x9,%eax
801028c0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c1:	89 ca                	mov    %ecx,%edx
801028c3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028c7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028cd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028d0:	6a 18                	push   $0x18
801028d2:	56                   	push   %esi
801028d3:	50                   	push   %eax
801028d4:	e8 77 1b 00 00       	call   80104450 <memcmp>
801028d9:	83 c4 10             	add    $0x10,%esp
801028dc:	85 c0                	test   %eax,%eax
801028de:	0f 85 0c ff ff ff    	jne    801027f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028e4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028e8:	75 78                	jne    80102962 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ed:	89 c2                	mov    %eax,%edx
801028ef:	83 e0 0f             	and    $0xf,%eax
801028f2:	c1 ea 04             	shr    $0x4,%edx
801028f5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102901:	89 c2                	mov    %eax,%edx
80102903:	83 e0 0f             	and    $0xf,%eax
80102906:	c1 ea 04             	shr    $0x4,%edx
80102909:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102912:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102915:	89 c2                	mov    %eax,%edx
80102917:	83 e0 0f             	and    $0xf,%eax
8010291a:	c1 ea 04             	shr    $0x4,%edx
8010291d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102920:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102923:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102926:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102929:	89 c2                	mov    %eax,%edx
8010292b:	83 e0 0f             	and    $0xf,%eax
8010292e:	c1 ea 04             	shr    $0x4,%edx
80102931:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102934:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102937:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010293a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010293d:	89 c2                	mov    %eax,%edx
8010293f:	83 e0 0f             	and    $0xf,%eax
80102942:	c1 ea 04             	shr    $0x4,%edx
80102945:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102948:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010294e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102951:	89 c2                	mov    %eax,%edx
80102953:	83 e0 0f             	and    $0xf,%eax
80102956:	c1 ea 04             	shr    $0x4,%edx
80102959:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102962:	8b 75 08             	mov    0x8(%ebp),%esi
80102965:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102968:	89 06                	mov    %eax,(%esi)
8010296a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010296d:	89 46 04             	mov    %eax,0x4(%esi)
80102970:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102973:	89 46 08             	mov    %eax,0x8(%esi)
80102976:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102979:	89 46 0c             	mov    %eax,0xc(%esi)
8010297c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297f:	89 46 10             	mov    %eax,0x10(%esi)
80102982:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102985:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102988:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010298f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102992:	5b                   	pop    %ebx
80102993:	5e                   	pop    %esi
80102994:	5f                   	pop    %edi
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029a0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801029a6:	85 c9                	test   %ecx,%ecx
801029a8:	0f 8e 85 00 00 00    	jle    80102a33 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029ae:	55                   	push   %ebp
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	31 db                	xor    %ebx,%ebx
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029c0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029c5:	83 ec 08             	sub    $0x8,%esp
801029c8:	01 d8                	add    %ebx,%eax
801029ca:	83 c0 01             	add    $0x1,%eax
801029cd:	50                   	push   %eax
801029ce:	ff 35 c4 26 11 80    	pushl  0x801126c4
801029d4:	e8 f7 d6 ff ff       	call   801000d0 <bread>
801029d9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029db:	58                   	pop    %eax
801029dc:	5a                   	pop    %edx
801029dd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801029e4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ed:	e8 de d6 ff ff       	call   801000d0 <bread>
801029f2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029f4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029f7:	83 c4 0c             	add    $0xc,%esp
801029fa:	68 00 02 00 00       	push   $0x200
801029ff:	50                   	push   %eax
80102a00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a03:	50                   	push   %eax
80102a04:	e8 a7 1a 00 00       	call   801044b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a09:	89 34 24             	mov    %esi,(%esp)
80102a0c:	e8 8f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a11:	89 3c 24             	mov    %edi,(%esp)
80102a14:	e8 c7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 bf d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a2a:	7f 94                	jg     801029c0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a2f:	5b                   	pop    %ebx
80102a30:	5e                   	pop    %esi
80102a31:	5f                   	pop    %edi
80102a32:	5d                   	pop    %ebp
80102a33:	f3 c3                	repz ret 
80102a35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	53                   	push   %ebx
80102a44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a53:	e8 78 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a58:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a5e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a61:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a63:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a65:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a68:	7e 1f                	jle    80102a89 <write_head+0x49>
80102a6a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a71:	31 d2                	xor    %edx,%edx
80102a73:	90                   	nop
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a78:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102a7e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a82:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a85:	39 c2                	cmp    %eax,%edx
80102a87:	75 ef                	jne    80102a78 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a89:	83 ec 0c             	sub    $0xc,%esp
80102a8c:	53                   	push   %ebx
80102a8d:	e8 0e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a92:	89 1c 24             	mov    %ebx,(%esp)
80102a95:	e8 46 d7 ff ff       	call   801001e0 <brelse>
}
80102a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9d:	c9                   	leave  
80102a9e:	c3                   	ret    
80102a9f:	90                   	nop

80102aa0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	83 ec 2c             	sub    $0x2c,%esp
80102aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aaa:	68 c0 75 10 80       	push   $0x801075c0
80102aaf:	68 80 26 11 80       	push   $0x80112680
80102ab4:	e8 e7 16 00 00       	call   801041a0 <initlock>
  readsb(dev, &sb);
80102ab9:	58                   	pop    %eax
80102aba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102abd:	5a                   	pop    %edx
80102abe:	50                   	push   %eax
80102abf:	53                   	push   %ebx
80102ac0:	e8 5b e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102acc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102add:	5a                   	pop    %edx
80102ade:	50                   	push   %eax
80102adf:	53                   	push   %ebx
80102ae0:	e8 eb d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ae5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ae8:	83 c4 10             	add    $0x10,%esp
80102aeb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102aed:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102af3:	7e 1c                	jle    80102b11 <initlog+0x71>
80102af5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102afc:	31 d2                	xor    %edx,%edx
80102afe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b04:	83 c2 04             	add    $0x4,%edx
80102b07:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	50                   	push   %eax
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b1a:	e8 81 fe ff ff       	call   801029a0 <install_trans>
  log.lh.n = 0;
80102b1f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b26:	00 00 00 
  write_head(); // clear the log
80102b29:	e8 12 ff ff ff       	call   80102a40 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b31:	c9                   	leave  
80102b32:	c3                   	ret    
80102b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b46:	68 80 26 11 80       	push   $0x80112680
80102b4b:	e8 b0 17 00 00       	call   80104300 <acquire>
80102b50:	83 c4 10             	add    $0x10,%esp
80102b53:	eb 18                	jmp    80102b6d <begin_op+0x2d>
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	68 80 26 11 80       	push   $0x80112680
80102b60:	68 80 26 11 80       	push   $0x80112680
80102b65:	e8 a6 11 00 00       	call   80103d10 <sleep>
80102b6a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	75 e2                	jne    80102b58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b81:	83 c0 01             	add    $0x1,%eax
80102b84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b8a:	83 fa 1e             	cmp    $0x1e,%edx
80102b8d:	7f c9                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b97:	68 80 26 11 80       	push   $0x80112680
80102b9c:	e8 0f 18 00 00       	call   801043b0 <release>
      break;
    }
  }
}
80102ba1:	83 c4 10             	add    $0x10,%esp
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	68 80 26 11 80       	push   $0x80112680
80102bbe:	e8 3d 17 00 00       	call   80104300 <acquire>
  log.outstanding -= 1;
80102bc3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bc8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102bce:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bdb:	0f 85 23 01 00 00    	jne    80102d04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102be1:	85 c0                	test   %eax,%eax
80102be3:	0f 85 f7 00 00 00    	jne    80102ce0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bec:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bf3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bf6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf8:	68 80 26 11 80       	push   $0x80112680
80102bfd:	e8 ae 17 00 00       	call   801043b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c02:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c08:	83 c4 10             	add    $0x10,%esp
80102c0b:	85 c9                	test   %ecx,%ecx
80102c0d:	0f 8e 8a 00 00 00    	jle    80102c9d <end_op+0xed>
80102c13:	90                   	nop
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c18:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c1d:	83 ec 08             	sub    $0x8,%esp
80102c20:	01 d8                	add    %ebx,%eax
80102c22:	83 c0 01             	add    $0x1,%eax
80102c25:	50                   	push   %eax
80102c26:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c2c:	e8 9f d4 ff ff       	call   801000d0 <bread>
80102c31:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c33:	58                   	pop    %eax
80102c34:	5a                   	pop    %edx
80102c35:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c3c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c45:	e8 86 d4 ff ff       	call   801000d0 <bread>
80102c4a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c4c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c4f:	83 c4 0c             	add    $0xc,%esp
80102c52:	68 00 02 00 00       	push   $0x200
80102c57:	50                   	push   %eax
80102c58:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5b:	50                   	push   %eax
80102c5c:	e8 4f 18 00 00       	call   801044b0 <memmove>
    bwrite(to);  // write the log
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 37 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c69:	89 3c 24             	mov    %edi,(%esp)
80102c6c:	e8 6f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c79:	83 c4 10             	add    $0x10,%esp
80102c7c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c82:	7c 94                	jl     80102c18 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 b7 fd ff ff       	call   80102a40 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 12 fd ff ff       	call   801029a0 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 a3 fd ff ff       	call   80102a40 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c9d:	83 ec 0c             	sub    $0xc,%esp
80102ca0:	68 80 26 11 80       	push   $0x80112680
80102ca5:	e8 56 16 00 00       	call   80104300 <acquire>
    log.committing = 0;
    wakeup(&log);
80102caa:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cb1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cb8:	00 00 00 
    wakeup(&log);
80102cbb:	e8 00 12 00 00       	call   80103ec0 <wakeup>
    release(&log.lock);
80102cc0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc7:	e8 e4 16 00 00       	call   801043b0 <release>
80102ccc:	83 c4 10             	add    $0x10,%esp
  }
}
80102ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cd2:	5b                   	pop    %ebx
80102cd3:	5e                   	pop    %esi
80102cd4:	5f                   	pop    %edi
80102cd5:	5d                   	pop    %ebp
80102cd6:	c3                   	ret    
80102cd7:	89 f6                	mov    %esi,%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102ce0:	83 ec 0c             	sub    $0xc,%esp
80102ce3:	68 80 26 11 80       	push   $0x80112680
80102ce8:	e8 d3 11 00 00       	call   80103ec0 <wakeup>
  }
  release(&log.lock);
80102ced:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cf4:	e8 b7 16 00 00       	call   801043b0 <release>
80102cf9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d04:	83 ec 0c             	sub    $0xc,%esp
80102d07:	68 c4 75 10 80       	push   $0x801075c4
80102d0c:	e8 5f d6 ff ff       	call   80100370 <panic>
80102d11:	eb 0d                	jmp    80102d20 <log_write>
80102d13:	90                   	nop
80102d14:	90                   	nop
80102d15:	90                   	nop
80102d16:	90                   	nop
80102d17:	90                   	nop
80102d18:	90                   	nop
80102d19:	90                   	nop
80102d1a:	90                   	nop
80102d1b:	90                   	nop
80102d1c:	90                   	nop
80102d1d:	90                   	nop
80102d1e:	90                   	nop
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d30:	83 fa 1d             	cmp    $0x1d,%edx
80102d33:	0f 8f 97 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d39:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d3e:	83 e8 01             	sub    $0x1,%eax
80102d41:	39 c2                	cmp    %eax,%edx
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 87 00 00 00    	jle    80102ddd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 80 26 11 80       	push   $0x80112680
80102d5e:	e8 9d 15 00 00       	call   80104300 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d63:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d69:	83 c4 10             	add    $0x10,%esp
80102d6c:	83 fa 00             	cmp    $0x0,%edx
80102d6f:	7e 50                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d71:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d74:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d76:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102d7c:	75 0b                	jne    80102d89 <log_write+0x69>
80102d7e:	eb 38                	jmp    80102db8 <log_write+0x98>
80102d80:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dad:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dae:	e9 fd 15 00 00       	jmp    801043b0 <release>
80102db3:	90                   	nop
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 d3 75 10 80       	push   $0x801075d3
80102dd8:	e8 93 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddd:	83 ec 0c             	sub    $0xc,%esp
80102de0:	68 e9 75 10 80       	push   $0x801075e9
80102de5:	e8 86 d5 ff ff       	call   80100370 <panic>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102df7:	e8 44 09 00 00       	call   80103740 <cpuid>
80102dfc:	89 c3                	mov    %eax,%ebx
80102dfe:	e8 3d 09 00 00       	call   80103740 <cpuid>
80102e03:	83 ec 04             	sub    $0x4,%esp
80102e06:	53                   	push   %ebx
80102e07:	50                   	push   %eax
80102e08:	68 04 76 10 80       	push   $0x80107604
80102e0d:	e8 4e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e12:	e8 59 29 00 00       	call   80105770 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e17:	e8 a4 08 00 00       	call   801036c0 <mycpu>
80102e1c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e1e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e2a:	e8 f1 0b 00 00       	call   80103a20 <scheduler>
80102e2f:	90                   	nop

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 55 3a 00 00       	call   80106890 <switchkvm>
  seginit();
80102e3b:	e8 50 39 00 00       	call   80106790 <seginit>
  lapicinit();
80102e40:	e8 9b f7 ff ff       	call   801025e0 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	ff 71 fc             	pushl  -0x4(%ecx)
80102e5a:	55                   	push   %ebp
80102e5b:	89 e5                	mov    %esp,%ebp
80102e5d:	53                   	push   %ebx
80102e5e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e5f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e64:	83 ec 08             	sub    $0x8,%esp
80102e67:	68 00 00 40 80       	push   $0x80400000
80102e6c:	68 a8 54 11 80       	push   $0x801154a8
80102e71:	e8 3a f5 ff ff       	call   801023b0 <kinit1>
  kvmalloc();      // kernel page table
80102e76:	e8 b5 3e 00 00       	call   80106d30 <kvmalloc>
  mpinit();        // detect other processors
80102e7b:	e8 70 01 00 00       	call   80102ff0 <mpinit>
  lapicinit();     // interrupt controller
80102e80:	e8 5b f7 ff ff       	call   801025e0 <lapicinit>
  seginit();       // segment descriptors
80102e85:	e8 06 39 00 00       	call   80106790 <seginit>
  picinit();       // disable pic
80102e8a:	e8 31 03 00 00       	call   801031c0 <picinit>
  ioapicinit();    // another interrupt controller
80102e8f:	e8 4c f3 ff ff       	call   801021e0 <ioapicinit>
  consoleinit();   // console hardware
80102e94:	e8 07 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e99:	e8 c2 2b 00 00       	call   80105a60 <uartinit>
  pinit();         // process table
80102e9e:	e8 fd 07 00 00       	call   801036a0 <pinit>
  tvinit();        // trap vectors
80102ea3:	e8 28 28 00 00       	call   801056d0 <tvinit>
  binit();         // buffer cache
80102ea8:	e8 93 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ead:	e8 9e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102eb2:	e8 09 f1 ff ff       	call   80101fc0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eb7:	83 c4 0c             	add    $0xc,%esp
80102eba:	68 8a 00 00 00       	push   $0x8a
80102ebf:	68 8c a4 10 80       	push   $0x8010a48c
80102ec4:	68 00 70 00 80       	push   $0x80007000
80102ec9:	e8 e2 15 00 00       	call   801044b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ece:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed5:	00 00 00 
80102ed8:	83 c4 10             	add    $0x10,%esp
80102edb:	05 80 27 11 80       	add    $0x80112780,%eax
80102ee0:	39 d8                	cmp    %ebx,%eax
80102ee2:	76 6f                	jbe    80102f53 <main+0x103>
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ee8:	e8 d3 07 00 00       	call   801036c0 <mycpu>
80102eed:	39 d8                	cmp    %ebx,%eax
80102eef:	74 49                	je     80102f3a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ef1:	e8 8a f5 ff ff       	call   80102480 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ef6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102efb:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f02:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f05:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f0c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f0f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f14:	0f b6 03             	movzbl (%ebx),%eax
80102f17:	83 ec 08             	sub    $0x8,%esp
80102f1a:	68 00 70 00 00       	push   $0x7000
80102f1f:	50                   	push   %eax
80102f20:	e8 0b f8 ff ff       	call   80102730 <lapicstartap>
80102f25:	83 c4 10             	add    $0x10,%esp
80102f28:	90                   	nop
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 f6                	je     80102f30 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f3a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f41:	00 00 00 
80102f44:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f4a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f4f:	39 c3                	cmp    %eax,%ebx
80102f51:	72 95                	jb     80102ee8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f53:	83 ec 08             	sub    $0x8,%esp
80102f56:	68 00 00 00 8e       	push   $0x8e000000
80102f5b:	68 00 00 40 80       	push   $0x80400000
80102f60:	e8 bb f4 ff ff       	call   80102420 <kinit2>
  userinit();      // first user process
80102f65:	e8 26 08 00 00       	call   80103790 <userinit>
  mpmain();        // finish this processor's setup
80102f6a:	e8 81 fe ff ff       	call   80102df0 <mpmain>
80102f6f:	90                   	nop

80102f70 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f75:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f7c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f82:	39 de                	cmp    %ebx,%esi
80102f84:	73 48                	jae    80102fce <mpsearch1+0x5e>
80102f86:	8d 76 00             	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f90:	83 ec 04             	sub    $0x4,%esp
80102f93:	8d 7e 10             	lea    0x10(%esi),%edi
80102f96:	6a 04                	push   $0x4
80102f98:	68 18 76 10 80       	push   $0x80107618
80102f9d:	56                   	push   %esi
80102f9e:	e8 ad 14 00 00       	call   80104450 <memcmp>
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	75 1e                	jne    80102fc8 <mpsearch1+0x58>
80102faa:	8d 7e 10             	lea    0x10(%esi),%edi
80102fad:	89 f2                	mov    %esi,%edx
80102faf:	31 c9                	xor    %ecx,%ecx
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fb8:	0f b6 02             	movzbl (%edx),%eax
80102fbb:	83 c2 01             	add    $0x1,%edx
80102fbe:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fc0:	39 fa                	cmp    %edi,%edx
80102fc2:	75 f4                	jne    80102fb8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc4:	84 c9                	test   %cl,%cl
80102fc6:	74 10                	je     80102fd8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc8:	39 fb                	cmp    %edi,%ebx
80102fca:	89 fe                	mov    %edi,%esi
80102fcc:	77 c2                	ja     80102f90 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fd1:	31 c0                	xor    %eax,%eax
}
80102fd3:	5b                   	pop    %ebx
80102fd4:	5e                   	pop    %esi
80102fd5:	5f                   	pop    %edi
80102fd6:	5d                   	pop    %ebp
80102fd7:	c3                   	ret    
80102fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdb:	89 f0                	mov    %esi,%eax
80102fdd:	5b                   	pop    %ebx
80102fde:	5e                   	pop    %esi
80102fdf:	5f                   	pop    %edi
80102fe0:	5d                   	pop    %ebp
80102fe1:	c3                   	ret    
80102fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
80102ff5:	53                   	push   %ebx
80102ff6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ff9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103000:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103007:	c1 e0 08             	shl    $0x8,%eax
8010300a:	09 d0                	or     %edx,%eax
8010300c:	c1 e0 04             	shl    $0x4,%eax
8010300f:	85 c0                	test   %eax,%eax
80103011:	75 1b                	jne    8010302e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103013:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010301a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103021:	c1 e0 08             	shl    $0x8,%eax
80103024:	09 d0                	or     %edx,%eax
80103026:	c1 e0 0a             	shl    $0xa,%eax
80103029:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010302e:	ba 00 04 00 00       	mov    $0x400,%edx
80103033:	e8 38 ff ff ff       	call   80102f70 <mpsearch1>
80103038:	85 c0                	test   %eax,%eax
8010303a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010303d:	0f 84 37 01 00 00    	je     8010317a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103046:	8b 58 04             	mov    0x4(%eax),%ebx
80103049:	85 db                	test   %ebx,%ebx
8010304b:	0f 84 43 01 00 00    	je     80103194 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103051:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103057:	83 ec 04             	sub    $0x4,%esp
8010305a:	6a 04                	push   $0x4
8010305c:	68 1d 76 10 80       	push   $0x8010761d
80103061:	56                   	push   %esi
80103062:	e8 e9 13 00 00       	call   80104450 <memcmp>
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c0                	test   %eax,%eax
8010306c:	0f 85 22 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103072:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103079:	3c 01                	cmp    $0x1,%al
8010307b:	74 08                	je     80103085 <mpinit+0x95>
8010307d:	3c 04                	cmp    $0x4,%al
8010307f:	0f 85 0f 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103085:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010308c:	85 ff                	test   %edi,%edi
8010308e:	74 21                	je     801030b1 <mpinit+0xc1>
80103090:	31 d2                	xor    %edx,%edx
80103092:	31 c0                	xor    %eax,%eax
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103098:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010309f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030a3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a5:	39 c7                	cmp    %eax,%edi
801030a7:	75 ef                	jne    80103098 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a9:	84 d2                	test   %dl,%dl
801030ab:	0f 85 e3 00 00 00    	jne    80103194 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030b1:	85 f6                	test   %esi,%esi
801030b3:	0f 84 db 00 00 00    	je     80103194 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030b9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030bf:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030c4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030cb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030d1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d6:	01 d6                	add    %edx,%esi
801030d8:	90                   	nop
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e0:	39 c6                	cmp    %eax,%esi
801030e2:	76 23                	jbe    80103107 <mpinit+0x117>
801030e4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030e7:	80 fa 04             	cmp    $0x4,%dl
801030ea:	0f 87 c0 00 00 00    	ja     801031b0 <mpinit+0x1c0>
801030f0:	ff 24 95 5c 76 10 80 	jmp    *-0x7fef89a4(,%edx,4)
801030f7:	89 f6                	mov    %esi,%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103100:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103103:	39 c6                	cmp    %eax,%esi
80103105:	77 dd                	ja     801030e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103107:	85 db                	test   %ebx,%ebx
80103109:	0f 84 92 00 00 00    	je     801031a1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103112:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103116:	74 15                	je     8010312d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103118:	ba 22 00 00 00       	mov    $0x22,%edx
8010311d:	b8 70 00 00 00       	mov    $0x70,%eax
80103122:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103123:	ba 23 00 00 00       	mov    $0x23,%edx
80103128:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103129:	83 c8 01             	or     $0x1,%eax
8010312c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010312d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103130:	5b                   	pop    %ebx
80103131:	5e                   	pop    %esi
80103132:	5f                   	pop    %edi
80103133:	5d                   	pop    %ebp
80103134:	c3                   	ret    
80103135:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103138:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010313e:	83 f9 07             	cmp    $0x7,%ecx
80103141:	7f 19                	jg     8010315c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103143:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103147:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010314d:	83 c1 01             	add    $0x1,%ecx
80103150:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103156:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010315c:	83 c0 14             	add    $0x14,%eax
      continue;
8010315f:	e9 7c ff ff ff       	jmp    801030e0 <mpinit+0xf0>
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010316c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010316f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103175:	e9 66 ff ff ff       	jmp    801030e0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010317a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010317f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103184:	e8 e7 fd ff ff       	call   80102f70 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103189:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010318e:	0f 85 af fe ff ff    	jne    80103043 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103194:	83 ec 0c             	sub    $0xc,%esp
80103197:	68 22 76 10 80       	push   $0x80107622
8010319c:	e8 cf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031a1:	83 ec 0c             	sub    $0xc,%esp
801031a4:	68 3c 76 10 80       	push   $0x8010763c
801031a9:	e8 c2 d1 ff ff       	call   80100370 <panic>
801031ae:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031b0:	31 db                	xor    %ebx,%ebx
801031b2:	e9 30 ff ff ff       	jmp    801030e7 <mpinit+0xf7>
801031b7:	66 90                	xchg   %ax,%ax
801031b9:	66 90                	xchg   %ax,%ax
801031bb:	66 90                	xchg   %ax,%ax
801031bd:	66 90                	xchg   %ax,%ax
801031bf:	90                   	nop

801031c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031c0:	55                   	push   %ebp
801031c1:	ba 21 00 00 00       	mov    $0x21,%edx
801031c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	ee                   	out    %al,(%dx)
801031ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801031d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031d4:	5d                   	pop    %ebp
801031d5:	c3                   	ret    
801031d6:	66 90                	xchg   %ax,%ax
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 0c             	sub    $0xc,%esp
801031e9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031fb:	e8 70 db ff ff       	call   80100d70 <filealloc>
80103200:	85 c0                	test   %eax,%eax
80103202:	89 06                	mov    %eax,(%esi)
80103204:	0f 84 a8 00 00 00    	je     801032b2 <pipealloc+0xd2>
8010320a:	e8 61 db ff ff       	call   80100d70 <filealloc>
8010320f:	85 c0                	test   %eax,%eax
80103211:	89 03                	mov    %eax,(%ebx)
80103213:	0f 84 87 00 00 00    	je     801032a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103219:	e8 62 f2 ff ff       	call   80102480 <kalloc>
8010321e:	85 c0                	test   %eax,%eax
80103220:	89 c7                	mov    %eax,%edi
80103222:	0f 84 b0 00 00 00    	je     801032d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103228:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010322b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103232:	00 00 00 
  p->writeopen = 1;
80103235:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010323c:	00 00 00 
  p->nwrite = 0;
8010323f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103246:	00 00 00 
  p->nread = 0;
80103249:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103250:	00 00 00 
  initlock(&p->lock, "pipe");
80103253:	68 70 76 10 80       	push   $0x80107670
80103258:	50                   	push   %eax
80103259:	e8 42 0f 00 00       	call   801041a0 <initlock>
  (*f0)->type = FD_PIPE;
8010325e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103260:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103263:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103269:	8b 06                	mov    (%esi),%eax
8010326b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010326f:	8b 06                	mov    (%esi),%eax
80103271:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103275:	8b 06                	mov    (%esi),%eax
80103277:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010327a:	8b 03                	mov    (%ebx),%eax
8010327c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103282:	8b 03                	mov    (%ebx),%eax
80103284:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103288:	8b 03                	mov    (%ebx),%eax
8010328a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010328e:	8b 03                	mov    (%ebx),%eax
80103290:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103296:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103298:	5b                   	pop    %ebx
80103299:	5e                   	pop    %esi
8010329a:	5f                   	pop    %edi
8010329b:	5d                   	pop    %ebp
8010329c:	c3                   	ret    
8010329d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032a0:	8b 06                	mov    (%esi),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 1e                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f0);
801032a6:	83 ec 0c             	sub    $0xc,%esp
801032a9:	50                   	push   %eax
801032aa:	e8 81 db ff ff       	call   80100e30 <fileclose>
801032af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032b2:	8b 03                	mov    (%ebx),%eax
801032b4:	85 c0                	test   %eax,%eax
801032b6:	74 0c                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f1);
801032b8:	83 ec 0c             	sub    $0xc,%esp
801032bb:	50                   	push   %eax
801032bc:	e8 6f db ff ff       	call   80100e30 <fileclose>
801032c1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5f                   	pop    %edi
801032cf:	5d                   	pop    %ebp
801032d0:	c3                   	ret    
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032d8:	8b 06                	mov    (%esi),%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 c8                	jne    801032a6 <pipealloc+0xc6>
801032de:	eb d2                	jmp    801032b2 <pipealloc+0xd2>

801032e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	56                   	push   %esi
801032e4:	53                   	push   %ebx
801032e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	53                   	push   %ebx
801032ef:	e8 0c 10 00 00       	call   80104300 <acquire>
  if(writable){
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	85 f6                	test   %esi,%esi
801032f9:	74 45                	je     80103340 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103301:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103304:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010330b:	00 00 00 
    wakeup(&p->nread);
8010330e:	50                   	push   %eax
8010330f:	e8 ac 0b 00 00       	call   80103ec0 <wakeup>
80103314:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103317:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010331d:	85 d2                	test   %edx,%edx
8010331f:	75 0a                	jne    8010332b <pipeclose+0x4b>
80103321:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103327:	85 c0                	test   %eax,%eax
80103329:	74 35                	je     80103360 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010332b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010332e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103331:	5b                   	pop    %ebx
80103332:	5e                   	pop    %esi
80103333:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103334:	e9 77 10 00 00       	jmp    801043b0 <release>
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103340:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103346:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103349:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103350:	00 00 00 
    wakeup(&p->nwrite);
80103353:	50                   	push   %eax
80103354:	e8 67 0b 00 00       	call   80103ec0 <wakeup>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	eb b9                	jmp    80103317 <pipeclose+0x37>
8010335e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	53                   	push   %ebx
80103364:	e8 47 10 00 00       	call   801043b0 <release>
    kfree((char*)p);
80103369:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010336c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010336f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103375:	e9 56 ef ff ff       	jmp    801022d0 <kfree>
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103380 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 28             	sub    $0x28,%esp
80103389:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010338c:	53                   	push   %ebx
8010338d:	e8 6e 0f 00 00       	call   80104300 <acquire>
  for(i = 0; i < n; i++){
80103392:	8b 45 10             	mov    0x10(%ebp),%eax
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	85 c0                	test   %eax,%eax
8010339a:	0f 8e b9 00 00 00    	jle    80103459 <pipewrite+0xd9>
801033a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033a3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033af:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033b8:	03 4d 10             	add    0x10(%ebp),%ecx
801033bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033be:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033c4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ca:	39 d0                	cmp    %edx,%eax
801033cc:	74 38                	je     80103406 <pipewrite+0x86>
801033ce:	eb 59                	jmp    80103429 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033d0:	e8 8b 03 00 00       	call   80103760 <myproc>
801033d5:	8b 48 24             	mov    0x24(%eax),%ecx
801033d8:	85 c9                	test   %ecx,%ecx
801033da:	75 34                	jne    80103410 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033dc:	83 ec 0c             	sub    $0xc,%esp
801033df:	57                   	push   %edi
801033e0:	e8 db 0a 00 00       	call   80103ec0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033e5:	58                   	pop    %eax
801033e6:	5a                   	pop    %edx
801033e7:	53                   	push   %ebx
801033e8:	56                   	push   %esi
801033e9:	e8 22 09 00 00       	call   80103d10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033fa:	83 c4 10             	add    $0x10,%esp
801033fd:	05 00 02 00 00       	add    $0x200,%eax
80103402:	39 c2                	cmp    %eax,%edx
80103404:	75 2a                	jne    80103430 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103406:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010340c:	85 c0                	test   %eax,%eax
8010340e:	75 c0                	jne    801033d0 <pipewrite+0x50>
        release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 97 0f 00 00       	call   801043b0 <release>
        return -1;
80103419:	83 c4 10             	add    $0x10,%esp
8010341c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103424:	5b                   	pop    %ebx
80103425:	5e                   	pop    %esi
80103426:	5f                   	pop    %edi
80103427:	5d                   	pop    %ebp
80103428:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103429:	89 c2                	mov    %eax,%edx
8010342b:	90                   	nop
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103430:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103433:	8d 42 01             	lea    0x1(%edx),%eax
80103436:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010343a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103440:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103446:	0f b6 09             	movzbl (%ecx),%ecx
80103449:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010344d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103450:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103453:	0f 85 65 ff ff ff    	jne    801033be <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103459:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	50                   	push   %eax
80103463:	e8 58 0a 00 00       	call   80103ec0 <wakeup>
  release(&p->lock);
80103468:	89 1c 24             	mov    %ebx,(%esp)
8010346b:	e8 40 0f 00 00       	call   801043b0 <release>
  return n;
80103470:	83 c4 10             	add    $0x10,%esp
80103473:	8b 45 10             	mov    0x10(%ebp),%eax
80103476:	eb a9                	jmp    80103421 <pipewrite+0xa1>
80103478:	90                   	nop
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103480 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 18             	sub    $0x18,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010348f:	53                   	push   %ebx
80103490:	e8 6b 0e 00 00       	call   80104300 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103495:	83 c4 10             	add    $0x10,%esp
80103498:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010349e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801034a4:	75 6a                	jne    80103510 <piperead+0x90>
801034a6:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034ac:	85 c0                	test   %eax,%eax
801034ae:	0f 84 c4 00 00 00    	je     80103578 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034b4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ba:	eb 2d                	jmp    801034e9 <piperead+0x69>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c0:	83 ec 08             	sub    $0x8,%esp
801034c3:	53                   	push   %ebx
801034c4:	56                   	push   %esi
801034c5:	e8 46 08 00 00       	call   80103d10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034d3:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801034d9:	75 35                	jne    80103510 <piperead+0x90>
801034db:	8b 8b 40 02 00 00    	mov    0x240(%ebx),%ecx
801034e1:	85 c9                	test   %ecx,%ecx
801034e3:	0f 84 8f 00 00 00    	je     80103578 <piperead+0xf8>
    if(myproc()->killed){
801034e9:	e8 72 02 00 00       	call   80103760 <myproc>
801034ee:	8b 40 24             	mov    0x24(%eax),%eax
801034f1:	85 c0                	test   %eax,%eax
801034f3:	74 cb                	je     801034c0 <piperead+0x40>
      release(&p->lock);
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	53                   	push   %ebx
801034f9:	e8 b2 0e 00 00       	call   801043b0 <release>
      return -1;
801034fe:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103501:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103509:	5b                   	pop    %ebx
8010350a:	5e                   	pop    %esi
8010350b:	5f                   	pop    %edi
8010350c:	5d                   	pop    %ebp
8010350d:	c3                   	ret    
8010350e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103510:	8b 55 10             	mov    0x10(%ebp),%edx
80103513:	85 d2                	test   %edx,%edx
80103515:	7e 61                	jle    80103578 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103517:	31 c9                	xor    %ecx,%ecx
80103519:	eb 13                	jmp    8010352e <piperead+0xae>
8010351b:	90                   	nop
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103520:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103526:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010352c:	74 5a                	je     80103588 <piperead+0x108>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010352e:	8d 70 01             	lea    0x1(%eax),%esi
80103531:	25 ff 01 00 00       	and    $0x1ff,%eax
80103536:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
8010353c:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103541:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103544:	83 c1 01             	add    $0x1,%ecx
80103547:	39 4d 10             	cmp    %ecx,0x10(%ebp)
8010354a:	75 d4                	jne    80103520 <piperead+0xa0>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010354c:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103552:	83 ec 0c             	sub    $0xc,%esp
80103555:	50                   	push   %eax
80103556:	e8 65 09 00 00       	call   80103ec0 <wakeup>
  release(&p->lock);
8010355b:	89 1c 24             	mov    %ebx,(%esp)
8010355e:	e8 4d 0e 00 00       	call   801043b0 <release>
  return i;
80103563:	8b 45 10             	mov    0x10(%ebp),%eax
80103566:	83 c4 10             	add    $0x10,%esp
}
80103569:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010356c:	5b                   	pop    %ebx
8010356d:	5e                   	pop    %esi
8010356e:	5f                   	pop    %edi
8010356f:	5d                   	pop    %ebp
80103570:	c3                   	ret    
80103571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103578:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
8010357f:	eb cb                	jmp    8010354c <piperead+0xcc>
80103581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103588:	89 4d 10             	mov    %ecx,0x10(%ebp)
8010358b:	eb bf                	jmp    8010354c <piperead+0xcc>
8010358d:	66 90                	xchg   %ax,%ax
8010358f:	90                   	nop

80103590 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103594:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103599:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010359c:	68 20 2d 11 80       	push   $0x80112d20
801035a1:	e8 5a 0d 00 00       	call   80104300 <acquire>
801035a6:	83 c4 10             	add    $0x10,%esp
801035a9:	eb 10                	jmp    801035bb <allocproc+0x2b>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b0:	83 c3 7c             	add    $0x7c,%ebx
801035b3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801035b9:	74 75                	je     80103630 <allocproc+0xa0>
    if(p->state == UNUSED)
801035bb:	8b 43 0c             	mov    0xc(%ebx),%eax
801035be:	85 c0                	test   %eax,%eax
801035c0:	75 ee                	jne    801035b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035c2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035c7:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035ca:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801035d1:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035d6:	8d 50 01             	lea    0x1(%eax),%edx
801035d9:	89 43 10             	mov    %eax,0x10(%ebx)
801035dc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
801035e2:	e8 c9 0d 00 00       	call   801043b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801035e7:	e8 94 ee ff ff       	call   80102480 <kalloc>
801035ec:	83 c4 10             	add    $0x10,%esp
801035ef:	85 c0                	test   %eax,%eax
801035f1:	89 43 08             	mov    %eax,0x8(%ebx)
801035f4:	74 51                	je     80103647 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035fc:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103604:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103607:	c7 40 14 c2 56 10 80 	movl   $0x801056c2,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010360e:	6a 14                	push   $0x14
80103610:	6a 00                	push   $0x0
80103612:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103613:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103616:	e8 e5 0d 00 00       	call   80104400 <memset>
  p->context->eip = (uint)forkret;
8010361b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010361e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103621:	c7 40 10 50 36 10 80 	movl   $0x80103650,0x10(%eax)

  return p;
80103628:	89 d8                	mov    %ebx,%eax
}
8010362a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010362d:	c9                   	leave  
8010362e:	c3                   	ret    
8010362f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	68 20 2d 11 80       	push   $0x80112d20
80103638:	e8 73 0d 00 00       	call   801043b0 <release>
  return 0;
8010363d:	83 c4 10             	add    $0x10,%esp
80103640:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103645:	c9                   	leave  
80103646:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103647:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010364e:	eb da                	jmp    8010362a <allocproc+0x9a>

80103650 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103656:	68 20 2d 11 80       	push   $0x80112d20
8010365b:	e8 50 0d 00 00       	call   801043b0 <release>

  if (first) {
80103660:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	85 c0                	test   %eax,%eax
8010366a:	75 04                	jne    80103670 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010366c:	c9                   	leave  
8010366d:	c3                   	ret    
8010366e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103670:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103673:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010367a:	00 00 00 
    iinit(ROOTDEV);
8010367d:	6a 01                	push   $0x1
8010367f:	e8 dc dd ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
80103684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010368b:	e8 10 f4 ff ff       	call   80102aa0 <initlog>
80103690:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103693:	c9                   	leave  
80103694:	c3                   	ret    
80103695:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036a6:	68 75 76 10 80       	push   $0x80107675
801036ab:	68 20 2d 11 80       	push   $0x80112d20
801036b0:	e8 eb 0a 00 00       	call   801041a0 <initlock>
}
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	c9                   	leave  
801036b9:	c3                   	ret    
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036c0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036c5:	9c                   	pushf  
801036c6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036c7:	f6 c4 02             	test   $0x2,%ah
801036ca:	75 5b                	jne    80103727 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036cc:	e8 0f f0 ff ff       	call   801026e0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036d1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801036d7:	85 f6                	test   %esi,%esi
801036d9:	7e 3f                	jle    8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036db:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801036e2:	39 d0                	cmp    %edx,%eax
801036e4:	74 30                	je     80103716 <mycpu+0x56>
801036e6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801036eb:	31 d2                	xor    %edx,%edx
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036f0:	83 c2 01             	add    $0x1,%edx
801036f3:	39 f2                	cmp    %esi,%edx
801036f5:	74 23                	je     8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036f7:	0f b6 19             	movzbl (%ecx),%ebx
801036fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103700:	39 d8                	cmp    %ebx,%eax
80103702:	75 ec                	jne    801036f0 <mycpu+0x30>
      return &cpus[i];
80103704:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010370a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010370d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010370e:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103713:	5e                   	pop    %esi
80103714:	5d                   	pop    %ebp
80103715:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103716:	31 d2                	xor    %edx,%edx
80103718:	eb ea                	jmp    80103704 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	68 7c 76 10 80       	push   $0x8010767c
80103722:	e8 49 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103727:	83 ec 0c             	sub    $0xc,%esp
8010372a:	68 58 77 10 80       	push   $0x80107758
8010372f:	e8 3c cc ff ff       	call   80100370 <panic>
80103734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010373a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103740 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103746:	e8 75 ff ff ff       	call   801036c0 <mycpu>
8010374b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103750:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103751:	c1 f8 04             	sar    $0x4,%eax
80103754:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010375a:	c3                   	ret    
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103760 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	53                   	push   %ebx
80103764:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103767:	e8 b4 0a 00 00       	call   80104220 <pushcli>
  c = mycpu();
8010376c:	e8 4f ff ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103771:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103777:	e8 e4 0a 00 00       	call   80104260 <popcli>
  return p;
}
8010377c:	83 c4 04             	add    $0x4,%esp
8010377f:	89 d8                	mov    %ebx,%eax
80103781:	5b                   	pop    %ebx
80103782:	5d                   	pop    %ebp
80103783:	c3                   	ret    
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103797:	e8 f4 fd ff ff       	call   80103590 <allocproc>
8010379c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010379e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037a3:	e8 08 35 00 00       	call   80106cb0 <setupkvm>
801037a8:	85 c0                	test   %eax,%eax
801037aa:	89 43 04             	mov    %eax,0x4(%ebx)
801037ad:	0f 84 bd 00 00 00    	je     80103870 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037b3:	83 ec 04             	sub    $0x4,%esp
801037b6:	68 2c 00 00 00       	push   $0x2c
801037bb:	68 60 a4 10 80       	push   $0x8010a460
801037c0:	50                   	push   %eax
801037c1:	e8 fa 31 00 00       	call   801069c0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801037c6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801037c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037cf:	6a 4c                	push   $0x4c
801037d1:	6a 00                	push   $0x0
801037d3:	ff 73 18             	pushl  0x18(%ebx)
801037d6:	e8 25 0c 00 00       	call   80104400 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037db:	8b 43 18             	mov    0x18(%ebx),%eax
801037de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037e3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037e8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037ef:	8b 43 18             	mov    0x18(%ebx),%eax
801037f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037f6:	8b 43 18             	mov    0x18(%ebx),%eax
801037f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103801:	8b 43 18             	mov    0x18(%ebx),%eax
80103804:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103808:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010380c:	8b 43 18             	mov    0x18(%ebx),%eax
8010380f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103816:	8b 43 18             	mov    0x18(%ebx),%eax
80103819:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103820:	8b 43 18             	mov    0x18(%ebx),%eax
80103823:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010382a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010382d:	6a 10                	push   $0x10
8010382f:	68 a5 76 10 80       	push   $0x801076a5
80103834:	50                   	push   %eax
80103835:	e8 c6 0d 00 00       	call   80104600 <safestrcpy>
  p->cwd = namei("/");
8010383a:	c7 04 24 ae 76 10 80 	movl   $0x801076ae,(%esp)
80103841:	e8 6a e6 ff ff       	call   80101eb0 <namei>
80103846:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103849:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103850:	e8 ab 0a 00 00       	call   80104300 <acquire>

  p->state = RUNNABLE;
80103855:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010385c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103863:	e8 48 0b 00 00       	call   801043b0 <release>
}
80103868:	83 c4 10             	add    $0x10,%esp
8010386b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386e:	c9                   	leave  
8010386f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	68 8c 76 10 80       	push   $0x8010768c
80103878:	e8 f3 ca ff ff       	call   80100370 <panic>
8010387d:	8d 76 00             	lea    0x0(%esi),%esi

80103880 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103888:	e8 93 09 00 00       	call   80104220 <pushcli>
  c = mycpu();
8010388d:	e8 2e fe ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103892:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103898:	e8 c3 09 00 00       	call   80104260 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010389d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
801038a0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801038a2:	7e 34                	jle    801038d8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038a4:	83 ec 04             	sub    $0x4,%esp
801038a7:	01 c6                	add    %eax,%esi
801038a9:	56                   	push   %esi
801038aa:	50                   	push   %eax
801038ab:	ff 73 04             	pushl  0x4(%ebx)
801038ae:	e8 4d 32 00 00       	call   80106b00 <allocuvm>
801038b3:	83 c4 10             	add    $0x10,%esp
801038b6:	85 c0                	test   %eax,%eax
801038b8:	74 36                	je     801038f0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801038ba:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038bd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038bf:	53                   	push   %ebx
801038c0:	e8 eb 2f 00 00       	call   801068b0 <switchuvm>
  return 0;
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	31 c0                	xor    %eax,%eax
}
801038ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038cd:	5b                   	pop    %ebx
801038ce:	5e                   	pop    %esi
801038cf:	5d                   	pop    %ebp
801038d0:	c3                   	ret    
801038d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038d8:	74 e0                	je     801038ba <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038da:	83 ec 04             	sub    $0x4,%esp
801038dd:	01 c6                	add    %eax,%esi
801038df:	56                   	push   %esi
801038e0:	50                   	push   %eax
801038e1:	ff 73 04             	pushl  0x4(%ebx)
801038e4:	e8 17 33 00 00       	call   80106c00 <deallocuvm>
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	85 c0                	test   %eax,%eax
801038ee:	75 ca                	jne    801038ba <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038f5:	eb d3                	jmp    801038ca <growproc+0x4a>
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103900 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103909:	e8 12 09 00 00       	call   80104220 <pushcli>
  c = mycpu();
8010390e:	e8 ad fd ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103913:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103919:	e8 42 09 00 00       	call   80104260 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010391e:	e8 6d fc ff ff       	call   80103590 <allocproc>
80103923:	85 c0                	test   %eax,%eax
80103925:	89 c7                	mov    %eax,%edi
80103927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010392a:	0f 84 b5 00 00 00    	je     801039e5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103930:	83 ec 08             	sub    $0x8,%esp
80103933:	ff 33                	pushl  (%ebx)
80103935:	ff 73 04             	pushl  0x4(%ebx)
80103938:	e8 43 34 00 00       	call   80106d80 <copyuvm>
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	85 c0                	test   %eax,%eax
80103942:	89 47 04             	mov    %eax,0x4(%edi)
80103945:	0f 84 a1 00 00 00    	je     801039ec <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010394b:	8b 03                	mov    (%ebx),%eax
8010394d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103950:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103952:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103955:	89 c8                	mov    %ecx,%eax
80103957:	8b 79 18             	mov    0x18(%ecx),%edi
8010395a:	8b 73 18             	mov    0x18(%ebx),%esi
8010395d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103962:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103964:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103966:	8b 40 18             	mov    0x18(%eax),%eax
80103969:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103970:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103974:	85 c0                	test   %eax,%eax
80103976:	74 13                	je     8010398b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103978:	83 ec 0c             	sub    $0xc,%esp
8010397b:	50                   	push   %eax
8010397c:	e8 5f d4 ff ff       	call   80100de0 <filedup>
80103981:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103984:	83 c4 10             	add    $0x10,%esp
80103987:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010398b:	83 c6 01             	add    $0x1,%esi
8010398e:	83 fe 10             	cmp    $0x10,%esi
80103991:	75 dd                	jne    80103970 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103993:	83 ec 0c             	sub    $0xc,%esp
80103996:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103999:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010399c:	e8 8f dc ff ff       	call   80101630 <idup>
801039a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039a4:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039a7:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039aa:	8d 47 6c             	lea    0x6c(%edi),%eax
801039ad:	6a 10                	push   $0x10
801039af:	53                   	push   %ebx
801039b0:	50                   	push   %eax
801039b1:	e8 4a 0c 00 00       	call   80104600 <safestrcpy>

  pid = np->pid;
801039b6:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039b9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039c0:	e8 3b 09 00 00       	call   80104300 <acquire>

  np->state = RUNNABLE;
801039c5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801039cc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d3:	e8 d8 09 00 00       	call   801043b0 <release>

  return pid;
801039d8:	83 c4 10             	add    $0x10,%esp
801039db:	89 d8                	mov    %ebx,%eax
}
801039dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e0:	5b                   	pop    %ebx
801039e1:	5e                   	pop    %esi
801039e2:	5f                   	pop    %edi
801039e3:	5d                   	pop    %ebp
801039e4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039ea:	eb f1                	jmp    801039dd <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
801039ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039ef:	83 ec 0c             	sub    $0xc,%esp
801039f2:	ff 77 08             	pushl  0x8(%edi)
801039f5:	e8 d6 e8 ff ff       	call   801022d0 <kfree>
    np->kstack = 0;
801039fa:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a01:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a08:	83 c4 10             	add    $0x10,%esp
80103a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a10:	eb cb                	jmp    801039dd <fork+0xdd>
80103a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a29:	e8 92 fc ff ff       	call   801036c0 <mycpu>
80103a2e:	8d 78 04             	lea    0x4(%eax),%edi
80103a31:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a33:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a3a:	00 00 00 
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a40:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a44:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a49:	68 20 2d 11 80       	push   $0x80112d20
80103a4e:	e8 ad 08 00 00       	call   80104300 <acquire>
80103a53:	83 c4 10             	add    $0x10,%esp
80103a56:	eb 13                	jmp    80103a6b <scheduler+0x4b>
80103a58:	90                   	nop
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a60:	83 c3 7c             	add    $0x7c,%ebx
80103a63:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103a69:	74 45                	je     80103ab0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103a6b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a6f:	75 ef                	jne    80103a60 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a71:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a74:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a7a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a7b:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a7e:	e8 2d 2e 00 00       	call   801068b0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a83:	58                   	pop    %eax
80103a84:	5a                   	pop    %edx
80103a85:	ff 73 a0             	pushl  -0x60(%ebx)
80103a88:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a89:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103a90:	e8 c6 0b 00 00       	call   8010465b <swtch>
      switchkvm();
80103a95:	e8 f6 2d 00 00       	call   80106890 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a9a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a9d:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103aa3:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103aaa:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aad:	75 bc                	jne    80103a6b <scheduler+0x4b>
80103aaf:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 20 2d 11 80       	push   $0x80112d20
80103ab8:	e8 f3 08 00 00       	call   801043b0 <release>

  }
80103abd:	83 c4 10             	add    $0x10,%esp
80103ac0:	e9 7b ff ff ff       	jmp    80103a40 <scheduler+0x20>
80103ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ad5:	e8 46 07 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103ada:	e8 e1 fb ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103adf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae5:	e8 76 07 00 00       	call   80104260 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 20 2d 11 80       	push   $0x80112d20
80103af2:	e8 d9 07 00 00       	call   801042d0 <holding>
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	85 c0                	test   %eax,%eax
80103afc:	74 4f                	je     80103b4d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103afe:	e8 bd fb ff ff       	call   801036c0 <mycpu>
80103b03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b0a:	75 68                	jne    80103b74 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103b0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b10:	74 55                	je     80103b67 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b12:	9c                   	pushf  
80103b13:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b14:	f6 c4 02             	test   $0x2,%ah
80103b17:	75 41                	jne    80103b5a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b19:	e8 a2 fb ff ff       	call   801036c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b1e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b27:	e8 94 fb ff ff       	call   801036c0 <mycpu>
80103b2c:	83 ec 08             	sub    $0x8,%esp
80103b2f:	ff 70 04             	pushl  0x4(%eax)
80103b32:	53                   	push   %ebx
80103b33:	e8 23 0b 00 00       	call   8010465b <swtch>
  mycpu()->intena = intena;
80103b38:	e8 83 fb ff ff       	call   801036c0 <mycpu>
}
80103b3d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103b40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b49:	5b                   	pop    %ebx
80103b4a:	5e                   	pop    %esi
80103b4b:	5d                   	pop    %ebp
80103b4c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 b0 76 10 80       	push   $0x801076b0
80103b55:	e8 16 c8 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 dc 76 10 80       	push   $0x801076dc
80103b62:	e8 09 c8 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b67:	83 ec 0c             	sub    $0xc,%esp
80103b6a:	68 ce 76 10 80       	push   $0x801076ce
80103b6f:	e8 fc c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b74:	83 ec 0c             	sub    $0xc,%esp
80103b77:	68 c2 76 10 80       	push   $0x801076c2
80103b7c:	e8 ef c7 ff ff       	call   80100370 <panic>
80103b81:	eb 0d                	jmp    80103b90 <exit>
80103b83:	90                   	nop
80103b84:	90                   	nop
80103b85:	90                   	nop
80103b86:	90                   	nop
80103b87:	90                   	nop
80103b88:	90                   	nop
80103b89:	90                   	nop
80103b8a:	90                   	nop
80103b8b:	90                   	nop
80103b8c:	90                   	nop
80103b8d:	90                   	nop
80103b8e:	90                   	nop
80103b8f:	90                   	nop

80103b90 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b99:	e8 82 06 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103b9e:	e8 1d fb ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103ba3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ba9:	e8 b2 06 00 00       	call   80104260 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103bae:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103bb4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103bb7:	8d 7e 68             	lea    0x68(%esi),%edi
80103bba:	0f 84 e7 00 00 00    	je     80103ca7 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103bc0:	8b 03                	mov    (%ebx),%eax
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	74 12                	je     80103bd8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103bc6:	83 ec 0c             	sub    $0xc,%esp
80103bc9:	50                   	push   %eax
80103bca:	e8 61 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103bcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103bd5:	83 c4 10             	add    $0x10,%esp
80103bd8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bdb:	39 df                	cmp    %ebx,%edi
80103bdd:	75 e1                	jne    80103bc0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bdf:	e8 5c ef ff ff       	call   80102b40 <begin_op>
  iput(curproc->cwd);
80103be4:	83 ec 0c             	sub    $0xc,%esp
80103be7:	ff 76 68             	pushl  0x68(%esi)
80103bea:	e8 a1 db ff ff       	call   80101790 <iput>
  end_op();
80103bef:	e8 bc ef ff ff       	call   80102bb0 <end_op>
  curproc->cwd = 0;
80103bf4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103bfb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c02:	e8 f9 06 00 00       	call   80104300 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c07:	8b 56 14             	mov    0x14(%esi),%edx
80103c0a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c0d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c12:	eb 0e                	jmp    80103c22 <exit+0x92>
80103c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c18:	83 c0 7c             	add    $0x7c,%eax
80103c1b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103c20:	74 1c                	je     80103c3e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103c22:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c26:	75 f0                	jne    80103c18 <exit+0x88>
80103c28:	3b 50 20             	cmp    0x20(%eax),%edx
80103c2b:	75 eb                	jne    80103c18 <exit+0x88>
      p->state = RUNNABLE;
80103c2d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c34:	83 c0 7c             	add    $0x7c,%eax
80103c37:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103c3c:	75 e4                	jne    80103c22 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c3e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c44:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c49:	eb 10                	jmp    80103c5b <exit+0xcb>
80103c4b:	90                   	nop
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c50:	83 c2 7c             	add    $0x7c,%edx
80103c53:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c59:	74 33                	je     80103c8e <exit+0xfe>
    if(p->parent == curproc){
80103c5b:	39 72 14             	cmp    %esi,0x14(%edx)
80103c5e:	75 f0                	jne    80103c50 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c60:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c64:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103c67:	75 e7                	jne    80103c50 <exit+0xc0>
80103c69:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c6e:	eb 0a                	jmp    80103c7a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	83 c0 7c             	add    $0x7c,%eax
80103c73:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103c78:	74 d6                	je     80103c50 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103c7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c7e:	75 f0                	jne    80103c70 <exit+0xe0>
80103c80:	3b 48 20             	cmp    0x20(%eax),%ecx
80103c83:	75 eb                	jne    80103c70 <exit+0xe0>
      p->state = RUNNABLE;
80103c85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103c8c:	eb e2                	jmp    80103c70 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c8e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103c95:	e8 36 fe ff ff       	call   80103ad0 <sched>
  panic("zombie exit");
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	68 fd 76 10 80       	push   $0x801076fd
80103ca2:	e8 c9 c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103ca7:	83 ec 0c             	sub    $0xc,%esp
80103caa:	68 f0 76 10 80       	push   $0x801076f0
80103caf:	e8 bc c6 ff ff       	call   80100370 <panic>
80103cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
80103cc4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cc7:	68 20 2d 11 80       	push   $0x80112d20
80103ccc:	e8 2f 06 00 00       	call   80104300 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cd1:	e8 4a 05 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103cd6:	e8 e5 f9 ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103cdb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce1:	e8 7a 05 00 00       	call   80104260 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103ce6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ced:	e8 de fd ff ff       	call   80103ad0 <sched>
  release(&ptable.lock);
80103cf2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf9:	e8 b2 06 00 00       	call   801043b0 <release>
}
80103cfe:	83 c4 10             	add    $0x10,%esp
80103d01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d04:	c9                   	leave  
80103d05:	c3                   	ret    
80103d06:	8d 76 00             	lea    0x0(%esi),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
80103d19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d1c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d1f:	e8 fc 04 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103d24:	e8 97 f9 ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103d29:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d2f:	e8 2c 05 00 00       	call   80104260 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103d34:	85 db                	test   %ebx,%ebx
80103d36:	0f 84 87 00 00 00    	je     80103dc3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103d3c:	85 f6                	test   %esi,%esi
80103d3e:	74 76                	je     80103db6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d40:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d46:	74 50                	je     80103d98 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	68 20 2d 11 80       	push   $0x80112d20
80103d50:	e8 ab 05 00 00       	call   80104300 <acquire>
    release(lk);
80103d55:	89 34 24             	mov    %esi,(%esp)
80103d58:	e8 53 06 00 00       	call   801043b0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d5d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d60:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d67:	e8 64 fd ff ff       	call   80103ad0 <sched>

  // Tidy up.
  p->chan = 0;
80103d6c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d73:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d7a:	e8 31 06 00 00       	call   801043b0 <release>
    acquire(lk);
80103d7f:	89 75 08             	mov    %esi,0x8(%ebp)
80103d82:	83 c4 10             	add    $0x10,%esp
  }
}
80103d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d88:	5b                   	pop    %ebx
80103d89:	5e                   	pop    %esi
80103d8a:	5f                   	pop    %edi
80103d8b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d8c:	e9 6f 05 00 00       	jmp    80104300 <acquire>
80103d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d98:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d9b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103da2:	e8 29 fd ff ff       	call   80103ad0 <sched>

  // Tidy up.
  p->chan = 0;
80103da7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db1:	5b                   	pop    %ebx
80103db2:	5e                   	pop    %esi
80103db3:	5f                   	pop    %edi
80103db4:	5d                   	pop    %ebp
80103db5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	68 0f 77 10 80       	push   $0x8010770f
80103dbe:	e8 ad c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	68 09 77 10 80       	push   $0x80107709
80103dcb:	e8 a0 c5 ff ff       	call   80100370 <panic>

80103dd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103dd5:	e8 46 04 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103dda:	e8 e1 f8 ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103ddf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103de5:	e8 76 04 00 00       	call   80104260 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	68 20 2d 11 80       	push   $0x80112d20
80103df2:	e8 09 05 00 00       	call   80104300 <acquire>
80103df7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dfa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dfc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e01:	eb 10                	jmp    80103e13 <wait+0x43>
80103e03:	90                   	nop
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e08:	83 c3 7c             	add    $0x7c,%ebx
80103e0b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103e11:	74 1d                	je     80103e30 <wait+0x60>
      if(p->parent != curproc)
80103e13:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e16:	75 f0                	jne    80103e08 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e18:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e1c:	74 30                	je     80103e4e <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e1e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103e21:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e26:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103e2c:	75 e5                	jne    80103e13 <wait+0x43>
80103e2e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e30:	85 c0                	test   %eax,%eax
80103e32:	74 70                	je     80103ea4 <wait+0xd4>
80103e34:	8b 46 24             	mov    0x24(%esi),%eax
80103e37:	85 c0                	test   %eax,%eax
80103e39:	75 69                	jne    80103ea4 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e3b:	83 ec 08             	sub    $0x8,%esp
80103e3e:	68 20 2d 11 80       	push   $0x80112d20
80103e43:	56                   	push   %esi
80103e44:	e8 c7 fe ff ff       	call   80103d10 <sleep>
  }
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	eb ac                	jmp    80103dfa <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e4e:	83 ec 0c             	sub    $0xc,%esp
80103e51:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e54:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e57:	e8 74 e4 ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e5c:	5a                   	pop    %edx
80103e5d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e60:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e67:	e8 c4 2d 00 00       	call   80106c30 <freevm>
        p->pid = 0;
80103e6c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e73:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e7a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e7e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e85:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e8c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e93:	e8 18 05 00 00       	call   801043b0 <release>
        return pid;
80103e98:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e9e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ea0:	5b                   	pop    %ebx
80103ea1:	5e                   	pop    %esi
80103ea2:	5d                   	pop    %ebp
80103ea3:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	68 20 2d 11 80       	push   $0x80112d20
80103eac:	e8 ff 04 00 00       	call   801043b0 <release>
      return -1;
80103eb1:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103eb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ebc:	5b                   	pop    %ebx
80103ebd:	5e                   	pop    %esi
80103ebe:	5d                   	pop    %ebp
80103ebf:	c3                   	ret    

80103ec0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 10             	sub    $0x10,%esp
80103ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eca:	68 20 2d 11 80       	push   $0x80112d20
80103ecf:	e8 2c 04 00 00       	call   80104300 <acquire>
80103ed4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103edc:	eb 0c                	jmp    80103eea <wakeup+0x2a>
80103ede:	66 90                	xchg   %ax,%ax
80103ee0:	83 c0 7c             	add    $0x7c,%eax
80103ee3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ee8:	74 1c                	je     80103f06 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <wakeup+0x20>
80103ef0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ef3:	75 eb                	jne    80103ee0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103efc:	83 c0 7c             	add    $0x7c,%eax
80103eff:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f04:	75 e4                	jne    80103eea <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f06:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f10:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f11:	e9 9a 04 00 00       	jmp    801043b0 <release>
80103f16:	8d 76 00             	lea    0x0(%esi),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 10             	sub    $0x10,%esp
80103f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f2a:	68 20 2d 11 80       	push   $0x80112d20
80103f2f:	e8 cc 03 00 00       	call   80104300 <acquire>
80103f34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f37:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f3c:	eb 0c                	jmp    80103f4a <kill+0x2a>
80103f3e:	66 90                	xchg   %ax,%ax
80103f40:	83 c0 7c             	add    $0x7c,%eax
80103f43:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f48:	74 3e                	je     80103f88 <kill+0x68>
    if(p->pid == pid){
80103f4a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f4d:	75 f1                	jne    80103f40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f4f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f53:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f5a:	74 1c                	je     80103f78 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f5c:	83 ec 0c             	sub    $0xc,%esp
80103f5f:	68 20 2d 11 80       	push   $0x80112d20
80103f64:	e8 47 04 00 00       	call   801043b0 <release>
      return 0;
80103f69:	83 c4 10             	add    $0x10,%esp
80103f6c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f71:	c9                   	leave  
80103f72:	c3                   	ret    
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f78:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f7f:	eb db                	jmp    80103f5c <kill+0x3c>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f88:	83 ec 0c             	sub    $0xc,%esp
80103f8b:	68 20 2d 11 80       	push   $0x80112d20
80103f90:	e8 1b 04 00 00       	call   801043b0 <release>
  return -1;
80103f95:	83 c4 10             	add    $0x10,%esp
80103f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fa0:	c9                   	leave  
80103fa1:	c3                   	ret    
80103fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fb9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103fbe:	83 ec 3c             	sub    $0x3c,%esp
80103fc1:	eb 24                	jmp    80103fe7 <procdump+0x37>
80103fc3:	90                   	nop
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	68 9f 7a 10 80       	push   $0x80107a9f
80103fd0:	e8 8b c6 ff ff       	call   80100660 <cprintf>
80103fd5:	83 c4 10             	add    $0x10,%esp
80103fd8:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fdb:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103fe1:	0f 84 81 00 00 00    	je     80104068 <procdump+0xb8>
    if(p->state == UNUSED)
80103fe7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 ea                	je     80103fd8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fee:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103ff1:	ba 20 77 10 80       	mov    $0x80107720,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ff6:	77 11                	ja     80104009 <procdump+0x59>
80103ff8:	8b 14 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fff:	b8 20 77 10 80       	mov    $0x80107720,%eax
80104004:	85 d2                	test   %edx,%edx
80104006:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104009:	53                   	push   %ebx
8010400a:	52                   	push   %edx
8010400b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010400e:	68 24 77 10 80       	push   $0x80107724
80104013:	e8 48 c6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104018:	83 c4 10             	add    $0x10,%esp
8010401b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010401f:	75 a7                	jne    80103fc8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104021:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104024:	83 ec 08             	sub    $0x8,%esp
80104027:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010402a:	50                   	push   %eax
8010402b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010402e:	8b 40 0c             	mov    0xc(%eax),%eax
80104031:	83 c0 08             	add    $0x8,%eax
80104034:	50                   	push   %eax
80104035:	e8 86 01 00 00       	call   801041c0 <getcallerpcs>
8010403a:	83 c4 10             	add    $0x10,%esp
8010403d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104040:	8b 17                	mov    (%edi),%edx
80104042:	85 d2                	test   %edx,%edx
80104044:	74 82                	je     80103fc8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104046:	83 ec 08             	sub    $0x8,%esp
80104049:	83 c7 04             	add    $0x4,%edi
8010404c:	52                   	push   %edx
8010404d:	68 61 71 10 80       	push   $0x80107161
80104052:	e8 09 c6 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104057:	83 c4 10             	add    $0x10,%esp
8010405a:	39 f7                	cmp    %esi,%edi
8010405c:	75 e2                	jne    80104040 <procdump+0x90>
8010405e:	e9 65 ff ff ff       	jmp    80103fc8 <procdump+0x18>
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104068:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010406b:	5b                   	pop    %ebx
8010406c:	5e                   	pop    %esi
8010406d:	5f                   	pop    %edi
8010406e:	5d                   	pop    %ebp
8010406f:	c3                   	ret    

80104070 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010407a:	68 98 77 10 80       	push   $0x80107798
8010407f:	8d 43 04             	lea    0x4(%ebx),%eax
80104082:	50                   	push   %eax
80104083:	e8 18 01 00 00       	call   801041a0 <initlock>
  lk->name = name;
80104088:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010408b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104091:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104094:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010409b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010409e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a1:	c9                   	leave  
801040a2:	c3                   	ret    
801040a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	8d 73 04             	lea    0x4(%ebx),%esi
801040be:	56                   	push   %esi
801040bf:	e8 3c 02 00 00       	call   80104300 <acquire>
  while (lk->locked) {
801040c4:	8b 13                	mov    (%ebx),%edx
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	85 d2                	test   %edx,%edx
801040cb:	74 16                	je     801040e3 <acquiresleep+0x33>
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801040d0:	83 ec 08             	sub    $0x8,%esp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	e8 36 fc ff ff       	call   80103d10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040da:	8b 03                	mov    (%ebx),%eax
801040dc:	83 c4 10             	add    $0x10,%esp
801040df:	85 c0                	test   %eax,%eax
801040e1:	75 ed                	jne    801040d0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040e9:	e8 72 f6 ff ff       	call   80103760 <myproc>
801040ee:	8b 40 10             	mov    0x10(%eax),%eax
801040f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040fa:	5b                   	pop    %ebx
801040fb:	5e                   	pop    %esi
801040fc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040fd:	e9 ae 02 00 00       	jmp    801043b0 <release>
80104102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104110 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
80104115:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	8d 73 04             	lea    0x4(%ebx),%esi
8010411e:	56                   	push   %esi
8010411f:	e8 dc 01 00 00       	call   80104300 <acquire>
  lk->locked = 0;
80104124:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010412a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104131:	89 1c 24             	mov    %ebx,(%esp)
80104134:	e8 87 fd ff ff       	call   80103ec0 <wakeup>
  release(&lk->lk);
80104139:	89 75 08             	mov    %esi,0x8(%ebp)
8010413c:	83 c4 10             	add    $0x10,%esp
}
8010413f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104142:	5b                   	pop    %ebx
80104143:	5e                   	pop    %esi
80104144:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104145:	e9 66 02 00 00       	jmp    801043b0 <release>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	31 ff                	xor    %edi,%edi
80104158:	83 ec 18             	sub    $0x18,%esp
8010415b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010415e:	8d 73 04             	lea    0x4(%ebx),%esi
80104161:	56                   	push   %esi
80104162:	e8 99 01 00 00       	call   80104300 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104167:	8b 03                	mov    (%ebx),%eax
80104169:	83 c4 10             	add    $0x10,%esp
8010416c:	85 c0                	test   %eax,%eax
8010416e:	74 13                	je     80104183 <holdingsleep+0x33>
80104170:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104173:	e8 e8 f5 ff ff       	call   80103760 <myproc>
80104178:	39 58 10             	cmp    %ebx,0x10(%eax)
8010417b:	0f 94 c0             	sete   %al
8010417e:	0f b6 c0             	movzbl %al,%eax
80104181:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104183:	83 ec 0c             	sub    $0xc,%esp
80104186:	56                   	push   %esi
80104187:	e8 24 02 00 00       	call   801043b0 <release>
  return r;
}
8010418c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010418f:	89 f8                	mov    %edi,%eax
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
80104196:	66 90                	xchg   %ax,%ax
80104198:	66 90                	xchg   %ax,%ax
8010419a:	66 90                	xchg   %ax,%ax
8010419c:	66 90                	xchg   %ax,%ax
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801041a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801041a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801041af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801041b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801041b9:	5d                   	pop    %ebp
801041ba:	c3                   	ret    
801041bb:	90                   	nop
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041c4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801041cd:	31 c0                	xor    %eax,%eax
801041cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041dc:	77 1a                	ja     801041f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041de:	8b 5a 04             	mov    0x4(%edx),%ebx
801041e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041e4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041e7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041e9:	83 f8 0a             	cmp    $0xa,%eax
801041ec:	75 e2                	jne    801041d0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ee:	5b                   	pop    %ebx
801041ef:	5d                   	pop    %ebp
801041f0:	c3                   	ret    
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041ff:	83 c0 01             	add    $0x1,%eax
80104202:	83 f8 0a             	cmp    $0xa,%eax
80104205:	74 e7                	je     801041ee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104207:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010420e:	83 c0 01             	add    $0x1,%eax
80104211:	83 f8 0a             	cmp    $0xa,%eax
80104214:	75 e2                	jne    801041f8 <getcallerpcs+0x38>
80104216:	eb d6                	jmp    801041ee <getcallerpcs+0x2e>
80104218:	90                   	nop
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 04             	sub    $0x4,%esp
80104227:	9c                   	pushf  
80104228:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104229:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010422a:	e8 91 f4 ff ff       	call   801036c0 <mycpu>
8010422f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104235:	85 c0                	test   %eax,%eax
80104237:	75 11                	jne    8010424a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104239:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010423f:	e8 7c f4 ff ff       	call   801036c0 <mycpu>
80104244:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010424a:	e8 71 f4 ff ff       	call   801036c0 <mycpu>
8010424f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104256:	83 c4 04             	add    $0x4,%esp
80104259:	5b                   	pop    %ebx
8010425a:	5d                   	pop    %ebp
8010425b:	c3                   	ret    
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <popcli>:

void
popcli(void)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104266:	9c                   	pushf  
80104267:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104268:	f6 c4 02             	test   $0x2,%ah
8010426b:	75 52                	jne    801042bf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010426d:	e8 4e f4 ff ff       	call   801036c0 <mycpu>
80104272:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104278:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010427b:	85 d2                	test   %edx,%edx
8010427d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104283:	78 2d                	js     801042b2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104285:	e8 36 f4 ff ff       	call   801036c0 <mycpu>
8010428a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104290:	85 d2                	test   %edx,%edx
80104292:	74 0c                	je     801042a0 <popcli+0x40>
    sti();
}
80104294:	c9                   	leave  
80104295:	c3                   	ret    
80104296:	8d 76 00             	lea    0x0(%esi),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042a0:	e8 1b f4 ff ff       	call   801036c0 <mycpu>
801042a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042ab:	85 c0                	test   %eax,%eax
801042ad:	74 e5                	je     80104294 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801042af:	fb                   	sti    
    sti();
}
801042b0:	c9                   	leave  
801042b1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801042b2:	83 ec 0c             	sub    $0xc,%esp
801042b5:	68 ba 77 10 80       	push   $0x801077ba
801042ba:	e8 b1 c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801042bf:	83 ec 0c             	sub    $0xc,%esp
801042c2:	68 a3 77 10 80       	push   $0x801077a3
801042c7:	e8 a4 c0 ff ff       	call   80100370 <panic>
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	56                   	push   %esi
801042d4:	53                   	push   %ebx
801042d5:	8b 75 08             	mov    0x8(%ebp),%esi
801042d8:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
801042da:	e8 41 ff ff ff       	call   80104220 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801042df:	8b 06                	mov    (%esi),%eax
801042e1:	85 c0                	test   %eax,%eax
801042e3:	74 10                	je     801042f5 <holding+0x25>
801042e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801042e8:	e8 d3 f3 ff ff       	call   801036c0 <mycpu>
801042ed:	39 c3                	cmp    %eax,%ebx
801042ef:	0f 94 c3             	sete   %bl
801042f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801042f5:	e8 66 ff ff ff       	call   80104260 <popcli>
  return r;
}
801042fa:	89 d8                	mov    %ebx,%eax
801042fc:	5b                   	pop    %ebx
801042fd:	5e                   	pop    %esi
801042fe:	5d                   	pop    %ebp
801042ff:	c3                   	ret    

80104300 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104307:	e8 14 ff ff ff       	call   80104220 <pushcli>
  if(holding(lk))
8010430c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	53                   	push   %ebx
80104313:	e8 b8 ff ff ff       	call   801042d0 <holding>
80104318:	83 c4 10             	add    $0x10,%esp
8010431b:	85 c0                	test   %eax,%eax
8010431d:	0f 85 7d 00 00 00    	jne    801043a0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104323:	ba 01 00 00 00       	mov    $0x1,%edx
80104328:	eb 09                	jmp    80104333 <acquire+0x33>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104330:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104333:	89 d0                	mov    %edx,%eax
80104335:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104338:	85 c0                	test   %eax,%eax
8010433a:	75 f4                	jne    80104330 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010433c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104341:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104344:	e8 77 f3 ff ff       	call   801036c0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104349:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010434b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010434e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104351:	31 c0                	xor    %eax,%eax
80104353:	90                   	nop
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104358:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010435e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104364:	77 1a                	ja     80104380 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104366:	8b 5a 04             	mov    0x4(%edx),%ebx
80104369:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010436c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010436f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104371:	83 f8 0a             	cmp    $0xa,%eax
80104374:	75 e2                	jne    80104358 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104379:	c9                   	leave  
8010437a:	c3                   	ret    
8010437b:	90                   	nop
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104380:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104387:	83 c0 01             	add    $0x1,%eax
8010438a:	83 f8 0a             	cmp    $0xa,%eax
8010438d:	74 e7                	je     80104376 <acquire+0x76>
    pcs[i] = 0;
8010438f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104396:	83 c0 01             	add    $0x1,%eax
80104399:	83 f8 0a             	cmp    $0xa,%eax
8010439c:	75 e2                	jne    80104380 <acquire+0x80>
8010439e:	eb d6                	jmp    80104376 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 c1 77 10 80       	push   $0x801077c1
801043a8:	e8 c3 bf ff ff       	call   80100370 <panic>
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801043ba:	53                   	push   %ebx
801043bb:	e8 10 ff ff ff       	call   801042d0 <holding>
801043c0:	83 c4 10             	add    $0x10,%esp
801043c3:	85 c0                	test   %eax,%eax
801043c5:	74 22                	je     801043e9 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
801043c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801043ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801043d5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801043da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801043e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e3:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801043e4:	e9 77 fe ff ff       	jmp    80104260 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801043e9:	83 ec 0c             	sub    $0xc,%esp
801043ec:	68 c9 77 10 80       	push   $0x801077c9
801043f1:	e8 7a bf ff ff       	call   80100370 <panic>
801043f6:	66 90                	xchg   %ax,%ax
801043f8:	66 90                	xchg   %ax,%ax
801043fa:	66 90                	xchg   %ax,%ax
801043fc:	66 90                	xchg   %ax,%ax
801043fe:	66 90                	xchg   %ax,%ax

80104400 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	53                   	push   %ebx
80104405:	8b 55 08             	mov    0x8(%ebp),%edx
80104408:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010440b:	f6 c2 03             	test   $0x3,%dl
8010440e:	75 05                	jne    80104415 <memset+0x15>
80104410:	f6 c1 03             	test   $0x3,%cl
80104413:	74 13                	je     80104428 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104415:	89 d7                	mov    %edx,%edi
80104417:	8b 45 0c             	mov    0xc(%ebp),%eax
8010441a:	fc                   	cld    
8010441b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010441d:	5b                   	pop    %ebx
8010441e:	89 d0                	mov    %edx,%eax
80104420:	5f                   	pop    %edi
80104421:	5d                   	pop    %ebp
80104422:	c3                   	ret    
80104423:	90                   	nop
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104428:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010442c:	c1 e9 02             	shr    $0x2,%ecx
8010442f:	89 fb                	mov    %edi,%ebx
80104431:	89 f8                	mov    %edi,%eax
80104433:	c1 e3 18             	shl    $0x18,%ebx
80104436:	c1 e0 10             	shl    $0x10,%eax
80104439:	09 d8                	or     %ebx,%eax
8010443b:	09 f8                	or     %edi,%eax
8010443d:	c1 e7 08             	shl    $0x8,%edi
80104440:	09 f8                	or     %edi,%eax
80104442:	89 d7                	mov    %edx,%edi
80104444:	fc                   	cld    
80104445:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104447:	5b                   	pop    %ebx
80104448:	89 d0                	mov    %edx,%eax
8010444a:	5f                   	pop    %edi
8010444b:	5d                   	pop    %ebp
8010444c:	c3                   	ret    
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	56                   	push   %esi
80104455:	8b 45 10             	mov    0x10(%ebp),%eax
80104458:	53                   	push   %ebx
80104459:	8b 75 0c             	mov    0xc(%ebp),%esi
8010445c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010445f:	85 c0                	test   %eax,%eax
80104461:	74 29                	je     8010448c <memcmp+0x3c>
    if(*s1 != *s2)
80104463:	0f b6 13             	movzbl (%ebx),%edx
80104466:	0f b6 0e             	movzbl (%esi),%ecx
80104469:	38 ca                	cmp    %cl,%dl
8010446b:	75 2b                	jne    80104498 <memcmp+0x48>
8010446d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104470:	31 c0                	xor    %eax,%eax
80104472:	eb 14                	jmp    80104488 <memcmp+0x38>
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104478:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010447d:	83 c0 01             	add    $0x1,%eax
80104480:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104484:	38 ca                	cmp    %cl,%dl
80104486:	75 10                	jne    80104498 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104488:	39 f8                	cmp    %edi,%eax
8010448a:	75 ec                	jne    80104478 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010448c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010448d:	31 c0                	xor    %eax,%eax
}
8010448f:	5e                   	pop    %esi
80104490:	5f                   	pop    %edi
80104491:	5d                   	pop    %ebp
80104492:	c3                   	ret    
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104498:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010449b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010449c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010449e:	5e                   	pop    %esi
8010449f:	5f                   	pop    %edi
801044a0:	5d                   	pop    %ebp
801044a1:	c3                   	ret    
801044a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	8b 45 08             	mov    0x8(%ebp),%eax
801044b8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044be:	39 c6                	cmp    %eax,%esi
801044c0:	73 2e                	jae    801044f0 <memmove+0x40>
801044c2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801044c5:	39 c8                	cmp    %ecx,%eax
801044c7:	73 27                	jae    801044f0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801044c9:	85 db                	test   %ebx,%ebx
801044cb:	8d 53 ff             	lea    -0x1(%ebx),%edx
801044ce:	74 17                	je     801044e7 <memmove+0x37>
      *--d = *--s;
801044d0:	29 d9                	sub    %ebx,%ecx
801044d2:	89 cb                	mov    %ecx,%ebx
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801044dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044df:	83 ea 01             	sub    $0x1,%edx
801044e2:	83 fa ff             	cmp    $0xffffffff,%edx
801044e5:	75 f1                	jne    801044d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044e7:	5b                   	pop    %ebx
801044e8:	5e                   	pop    %esi
801044e9:	5d                   	pop    %ebp
801044ea:	c3                   	ret    
801044eb:	90                   	nop
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044f0:	31 d2                	xor    %edx,%edx
801044f2:	85 db                	test   %ebx,%ebx
801044f4:	74 f1                	je     801044e7 <memmove+0x37>
801044f6:	8d 76 00             	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104500:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104504:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104507:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010450a:	39 d3                	cmp    %edx,%ebx
8010450c:	75 f2                	jne    80104500 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010450e:	5b                   	pop    %ebx
8010450f:	5e                   	pop    %esi
80104510:	5d                   	pop    %ebp
80104511:	c3                   	ret    
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104523:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104524:	eb 8a                	jmp    801044b0 <memmove>
80104526:	8d 76 00             	lea    0x0(%esi),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104538:	53                   	push   %ebx
80104539:	8b 7d 08             	mov    0x8(%ebp),%edi
8010453c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010453f:	85 c9                	test   %ecx,%ecx
80104541:	74 37                	je     8010457a <strncmp+0x4a>
80104543:	0f b6 17             	movzbl (%edi),%edx
80104546:	0f b6 1e             	movzbl (%esi),%ebx
80104549:	84 d2                	test   %dl,%dl
8010454b:	74 3f                	je     8010458c <strncmp+0x5c>
8010454d:	38 d3                	cmp    %dl,%bl
8010454f:	75 3b                	jne    8010458c <strncmp+0x5c>
80104551:	8d 47 01             	lea    0x1(%edi),%eax
80104554:	01 cf                	add    %ecx,%edi
80104556:	eb 1b                	jmp    80104573 <strncmp+0x43>
80104558:	90                   	nop
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104560:	0f b6 10             	movzbl (%eax),%edx
80104563:	84 d2                	test   %dl,%dl
80104565:	74 21                	je     80104588 <strncmp+0x58>
80104567:	0f b6 19             	movzbl (%ecx),%ebx
8010456a:	83 c0 01             	add    $0x1,%eax
    n--, p++, q++;
8010456d:	89 ce                	mov    %ecx,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010456f:	38 da                	cmp    %bl,%dl
80104571:	75 19                	jne    8010458c <strncmp+0x5c>
80104573:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104575:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104578:	75 e6                	jne    80104560 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010457a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010457b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010457d:	5e                   	pop    %esi
8010457e:	5f                   	pop    %edi
8010457f:	5d                   	pop    %ebp
80104580:	c3                   	ret    
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104588:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010458c:	0f b6 c2             	movzbl %dl,%eax
8010458f:	29 d8                	sub    %ebx,%eax
}
80104591:	5b                   	pop    %ebx
80104592:	5e                   	pop    %esi
80104593:	5f                   	pop    %edi
80104594:	5d                   	pop    %ebp
80104595:	c3                   	ret    
80104596:	8d 76 00             	lea    0x0(%esi),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 45 08             	mov    0x8(%ebp),%eax
801045a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801045ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801045ae:	89 c2                	mov    %eax,%edx
801045b0:	eb 19                	jmp    801045cb <strncpy+0x2b>
801045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045b8:	83 c3 01             	add    $0x1,%ebx
801045bb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045bf:	83 c2 01             	add    $0x1,%edx
801045c2:	84 c9                	test   %cl,%cl
801045c4:	88 4a ff             	mov    %cl,-0x1(%edx)
801045c7:	74 09                	je     801045d2 <strncpy+0x32>
801045c9:	89 f1                	mov    %esi,%ecx
801045cb:	85 c9                	test   %ecx,%ecx
801045cd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045d0:	7f e6                	jg     801045b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801045d2:	31 c9                	xor    %ecx,%ecx
801045d4:	85 f6                	test   %esi,%esi
801045d6:	7e 17                	jle    801045ef <strncpy+0x4f>
801045d8:	90                   	nop
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801045e0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801045e4:	89 f3                	mov    %esi,%ebx
801045e6:	83 c1 01             	add    $0x1,%ecx
801045e9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045eb:	85 db                	test   %ebx,%ebx
801045ed:	7f f1                	jg     801045e0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801045ef:	5b                   	pop    %ebx
801045f0:	5e                   	pop    %esi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    
801045f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104608:	8b 45 08             	mov    0x8(%ebp),%eax
8010460b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010460e:	85 c9                	test   %ecx,%ecx
80104610:	7e 26                	jle    80104638 <safestrcpy+0x38>
80104612:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104616:	89 c1                	mov    %eax,%ecx
80104618:	eb 17                	jmp    80104631 <safestrcpy+0x31>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104620:	83 c2 01             	add    $0x1,%edx
80104623:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104627:	83 c1 01             	add    $0x1,%ecx
8010462a:	84 db                	test   %bl,%bl
8010462c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010462f:	74 04                	je     80104635 <safestrcpy+0x35>
80104631:	39 f2                	cmp    %esi,%edx
80104633:	75 eb                	jne    80104620 <safestrcpy+0x20>
    ;
  *s = 0;
80104635:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104638:	5b                   	pop    %ebx
80104639:	5e                   	pop    %esi
8010463a:	5d                   	pop    %ebp
8010463b:	c3                   	ret    
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <strlen>:

int
strlen(const char *s)
{
80104640:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104641:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104643:	89 e5                	mov    %esp,%ebp
80104645:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104648:	80 3a 00             	cmpb   $0x0,(%edx)
8010464b:	74 0c                	je     80104659 <strlen+0x19>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
80104650:	83 c0 01             	add    $0x1,%eax
80104653:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104657:	75 f7                	jne    80104650 <strlen+0x10>
    ;
  return n;
}
80104659:	5d                   	pop    %ebp
8010465a:	c3                   	ret    

8010465b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010465b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010465f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104663:	55                   	push   %ebp
  pushl %ebx
80104664:	53                   	push   %ebx
  pushl %esi
80104665:	56                   	push   %esi
  pushl %edi
80104666:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104667:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104669:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010466b:	5f                   	pop    %edi
  popl %esi
8010466c:	5e                   	pop    %esi
  popl %ebx
8010466d:	5b                   	pop    %ebx
  popl %ebp
8010466e:	5d                   	pop    %ebp
  ret
8010466f:	c3                   	ret    

80104670 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 04             	sub    $0x4,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010467a:	e8 e1 f0 ff ff       	call   80103760 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz || addr == 0)
8010467f:	8b 00                	mov    (%eax),%eax
80104681:	39 d8                	cmp    %ebx,%eax
80104683:	76 1b                	jbe    801046a0 <fetchint+0x30>
80104685:	8d 53 04             	lea    0x4(%ebx),%edx
80104688:	39 d0                	cmp    %edx,%eax
8010468a:	72 14                	jb     801046a0 <fetchint+0x30>
8010468c:	85 db                	test   %ebx,%ebx
8010468e:	74 10                	je     801046a0 <fetchint+0x30>
    return -1;
  //cprintf("%x", addr);
  *ip = *(int*)(addr);
80104690:	8b 45 0c             	mov    0xc(%ebp),%eax
80104693:	8b 13                	mov    (%ebx),%edx
80104695:	89 10                	mov    %edx,(%eax)
  return 0;
80104697:	31 c0                	xor    %eax,%eax
}
80104699:	83 c4 04             	add    $0x4,%esp
8010469c:	5b                   	pop    %ebx
8010469d:	5d                   	pop    %ebp
8010469e:	c3                   	ret    
8010469f:	90                   	nop
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz || addr == 0)
    return -1;
801046a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a5:	eb f2                	jmp    80104699 <fetchint+0x29>
801046a7:	89 f6                	mov    %esi,%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 04             	sub    $0x4,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801046ba:	e8 a1 f0 ff ff       	call   80103760 <myproc>

  if(addr >= curproc->sz || addr == 0)
801046bf:	39 18                	cmp    %ebx,(%eax)
801046c1:	76 29                	jbe    801046ec <fetchstr+0x3c>
801046c3:	85 db                	test   %ebx,%ebx
801046c5:	74 25                	je     801046ec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801046c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801046ca:	89 da                	mov    %ebx,%edx
801046cc:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801046ce:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801046d0:	39 c3                	cmp    %eax,%ebx
801046d2:	73 18                	jae    801046ec <fetchstr+0x3c>
    if(*s == 0)
801046d4:	80 3b 00             	cmpb   $0x0,(%ebx)
801046d7:	75 0c                	jne    801046e5 <fetchstr+0x35>
801046d9:	eb 25                	jmp    80104700 <fetchstr+0x50>
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e0:	80 3a 00             	cmpb   $0x0,(%edx)
801046e3:	74 1b                	je     80104700 <fetchstr+0x50>

  if(addr >= curproc->sz || addr == 0)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801046e5:	83 c2 01             	add    $0x1,%edx
801046e8:	39 d0                	cmp    %edx,%eax
801046ea:	77 f4                	ja     801046e0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801046ec:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr == 0)
    return -1;
801046ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801046f4:	5b                   	pop    %ebx
801046f5:	5d                   	pop    %ebp
801046f6:	c3                   	ret    
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104700:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104703:	89 d0                	mov    %edx,%eax
80104705:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104707:	5b                   	pop    %ebx
80104708:	5d                   	pop    %ebp
80104709:	c3                   	ret    
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 75 0c             	mov    0xc(%ebp),%esi
80104718:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010471b:	e8 40 f0 ff ff       	call   80103760 <myproc>
80104720:	89 75 0c             	mov    %esi,0xc(%ebp)
80104723:	8b 40 18             	mov    0x18(%eax),%eax
80104726:	8b 40 44             	mov    0x44(%eax),%eax
80104729:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
}
8010472d:	5b                   	pop    %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010472e:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104731:	5e                   	pop    %esi
80104732:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104733:	e9 38 ff ff ff       	jmp    80104670 <fetchint>
80104738:	90                   	nop
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104740 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	83 ec 10             	sub    $0x10,%esp
80104748:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010474b:	e8 10 f0 ff ff       	call   80103760 <myproc>
80104750:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104752:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104755:	83 ec 08             	sub    $0x8,%esp
80104758:	50                   	push   %eax
80104759:	ff 75 08             	pushl  0x8(%ebp)
8010475c:	e8 af ff ff ff       	call   80104710 <argint>
80104761:	83 c4 10             	add    $0x10,%esp
80104764:	85 c0                	test   %eax,%eax
80104766:	78 30                	js     80104798 <argptr+0x58>
    return -1;
  //if(i<PGSIZE){
//    return -1;
//  }
  if((uint)i == 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz || size < 0)
80104768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476b:	85 c0                	test   %eax,%eax
8010476d:	74 29                	je     80104798 <argptr+0x58>
8010476f:	8b 16                	mov    (%esi),%edx
80104771:	39 c2                	cmp    %eax,%edx
80104773:	76 23                	jbe    80104798 <argptr+0x58>
80104775:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
80104778:	39 ca                	cmp    %ecx,%edx
8010477a:	72 1c                	jb     80104798 <argptr+0x58>
8010477c:	c1 eb 1f             	shr    $0x1f,%ebx
8010477f:	84 db                	test   %bl,%bl
80104781:	75 15                	jne    80104798 <argptr+0x58>

  //if this doesn't work delete conditional below and uncomment the one above
  //if((uint)i >= curproc->sz || (uint)i+size > curproc->sz|| (uint)i < PGSIZE ){
    //return -1;
  //}
  *pp = (char*)i;
80104783:	8b 55 0c             	mov    0xc(%ebp),%edx
80104786:	89 02                	mov    %eax,(%edx)
  return 0;
  

}
80104788:	8d 65 f8             	lea    -0x8(%ebp),%esp
  //if this doesn't work delete conditional below and uncomment the one above
  //if((uint)i >= curproc->sz || (uint)i+size > curproc->sz|| (uint)i < PGSIZE ){
    //return -1;
  //}
  *pp = (char*)i;
  return 0;
8010478b:	31 c0                	xor    %eax,%eax
  

}
8010478d:	5b                   	pop    %ebx
8010478e:	5e                   	pop    %esi
8010478f:	5d                   	pop    %ebp
80104790:	c3                   	ret    
80104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104798:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
8010479b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  //}
  *pp = (char*)i;
  return 0;
  

}
801047a0:	5b                   	pop    %ebx
801047a1:	5e                   	pop    %esi
801047a2:	5d                   	pop    %ebp
801047a3:	c3                   	ret    
801047a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801047b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047b9:	50                   	push   %eax
801047ba:	ff 75 08             	pushl  0x8(%ebp)
801047bd:	e8 4e ff ff ff       	call   80104710 <argint>
801047c2:	83 c4 10             	add    $0x10,%esp
801047c5:	85 c0                	test   %eax,%eax
801047c7:	78 17                	js     801047e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801047c9:	83 ec 08             	sub    $0x8,%esp
801047cc:	ff 75 0c             	pushl  0xc(%ebp)
801047cf:	ff 75 f4             	pushl  -0xc(%ebp)
801047d2:	e8 d9 fe ff ff       	call   801046b0 <fetchstr>
801047d7:	83 c4 10             	add    $0x10,%esp
}
801047da:	c9                   	leave  
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801047e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801047e5:	c9                   	leave  
801047e6:	c3                   	ret    
801047e7:	89 f6                	mov    %esi,%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <syscall>:
[SYS_munprotect] sys_munprotect,
};

void
syscall(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801047f5:	e8 66 ef ff ff       	call   80103760 <myproc>

  num = curproc->tf->eax;
801047fa:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801047fd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801047ff:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104802:	8d 50 ff             	lea    -0x1(%eax),%edx
80104805:	83 fa 16             	cmp    $0x16,%edx
80104808:	77 1e                	ja     80104828 <syscall+0x38>
8010480a:	8b 14 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%edx
80104811:	85 d2                	test   %edx,%edx
80104813:	74 13                	je     80104828 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104815:	ff d2                	call   *%edx
80104817:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010481a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010481d:	5b                   	pop    %ebx
8010481e:	5e                   	pop    %esi
8010481f:	5d                   	pop    %ebp
80104820:	c3                   	ret    
80104821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104828:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104829:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010482c:	50                   	push   %eax
8010482d:	ff 73 10             	pushl  0x10(%ebx)
80104830:	68 d1 77 10 80       	push   $0x801077d1
80104835:	e8 26 be ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010483a:	8b 43 18             	mov    0x18(%ebx),%eax
8010483d:	83 c4 10             	add    $0x10,%esp
80104840:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104847:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
8010484d:	c3                   	ret    
8010484e:	66 90                	xchg   %ax,%ax

80104850 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104856:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104859:	83 ec 34             	sub    $0x34,%esp
8010485c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010485f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104862:	56                   	push   %esi
80104863:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104864:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104867:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010486a:	e8 61 d6 ff ff       	call   80101ed0 <nameiparent>
8010486f:	83 c4 10             	add    $0x10,%esp
80104872:	85 c0                	test   %eax,%eax
80104874:	0f 84 f6 00 00 00    	je     80104970 <create+0x120>
    return 0;
  ilock(dp);
8010487a:	83 ec 0c             	sub    $0xc,%esp
8010487d:	89 c7                	mov    %eax,%edi
8010487f:	50                   	push   %eax
80104880:	e8 db cd ff ff       	call   80101660 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104885:	83 c4 0c             	add    $0xc,%esp
80104888:	6a 00                	push   $0x0
8010488a:	56                   	push   %esi
8010488b:	57                   	push   %edi
8010488c:	e8 ff d2 ff ff       	call   80101b90 <dirlookup>
80104891:	83 c4 10             	add    $0x10,%esp
80104894:	85 c0                	test   %eax,%eax
80104896:	89 c3                	mov    %eax,%ebx
80104898:	74 56                	je     801048f0 <create+0xa0>
    iunlockput(dp);
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	57                   	push   %edi
8010489e:	e8 4d d0 ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
801048a3:	89 1c 24             	mov    %ebx,(%esp)
801048a6:	e8 b5 cd ff ff       	call   80101660 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801048ab:	83 c4 10             	add    $0x10,%esp
801048ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801048b3:	75 1b                	jne    801048d0 <create+0x80>
801048b5:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801048ba:	89 d8                	mov    %ebx,%eax
801048bc:	75 12                	jne    801048d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c1:	5b                   	pop    %ebx
801048c2:	5e                   	pop    %esi
801048c3:	5f                   	pop    %edi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
801048c6:	8d 76 00             	lea    0x0(%esi),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801048d0:	83 ec 0c             	sub    $0xc,%esp
801048d3:	53                   	push   %ebx
801048d4:	e8 17 d0 ff ff       	call   801018f0 <iunlockput>
    return 0;
801048d9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048df:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048e1:	5b                   	pop    %ebx
801048e2:	5e                   	pop    %esi
801048e3:	5f                   	pop    %edi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	8d 76 00             	lea    0x0(%esi),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801048f4:	83 ec 08             	sub    $0x8,%esp
801048f7:	50                   	push   %eax
801048f8:	ff 37                	pushl  (%edi)
801048fa:	e8 f1 cb ff ff       	call   801014f0 <ialloc>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	89 c3                	mov    %eax,%ebx
80104906:	0f 84 cc 00 00 00    	je     801049d8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010490c:	83 ec 0c             	sub    $0xc,%esp
8010490f:	50                   	push   %eax
80104910:	e8 4b cd ff ff       	call   80101660 <ilock>
  ip->major = major;
80104915:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104919:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010491d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104921:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104925:	b8 01 00 00 00       	mov    $0x1,%eax
8010492a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010492e:	89 1c 24             	mov    %ebx,(%esp)
80104931:	e8 7a cc ff ff       	call   801015b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104936:	83 c4 10             	add    $0x10,%esp
80104939:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010493e:	74 40                	je     80104980 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104940:	83 ec 04             	sub    $0x4,%esp
80104943:	ff 73 04             	pushl  0x4(%ebx)
80104946:	56                   	push   %esi
80104947:	57                   	push   %edi
80104948:	e8 a3 d4 ff ff       	call   80101df0 <dirlink>
8010494d:	83 c4 10             	add    $0x10,%esp
80104950:	85 c0                	test   %eax,%eax
80104952:	78 77                	js     801049cb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104954:	83 ec 0c             	sub    $0xc,%esp
80104957:	57                   	push   %edi
80104958:	e8 93 cf ff ff       	call   801018f0 <iunlockput>

  return ip;
8010495d:	83 c4 10             	add    $0x10,%esp
}
80104960:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104963:	89 d8                	mov    %ebx,%eax
}
80104965:	5b                   	pop    %ebx
80104966:	5e                   	pop    %esi
80104967:	5f                   	pop    %edi
80104968:	5d                   	pop    %ebp
80104969:	c3                   	ret    
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104970:	31 c0                	xor    %eax,%eax
80104972:	e9 47 ff ff ff       	jmp    801048be <create+0x6e>
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104980:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104985:	83 ec 0c             	sub    $0xc,%esp
80104988:	57                   	push   %edi
80104989:	e8 22 cc ff ff       	call   801015b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010498e:	83 c4 0c             	add    $0xc,%esp
80104991:	ff 73 04             	pushl  0x4(%ebx)
80104994:	68 7c 78 10 80       	push   $0x8010787c
80104999:	53                   	push   %ebx
8010499a:	e8 51 d4 ff ff       	call   80101df0 <dirlink>
8010499f:	83 c4 10             	add    $0x10,%esp
801049a2:	85 c0                	test   %eax,%eax
801049a4:	78 18                	js     801049be <create+0x16e>
801049a6:	83 ec 04             	sub    $0x4,%esp
801049a9:	ff 77 04             	pushl  0x4(%edi)
801049ac:	68 7b 78 10 80       	push   $0x8010787b
801049b1:	53                   	push   %ebx
801049b2:	e8 39 d4 ff ff       	call   80101df0 <dirlink>
801049b7:	83 c4 10             	add    $0x10,%esp
801049ba:	85 c0                	test   %eax,%eax
801049bc:	79 82                	jns    80104940 <create+0xf0>
      panic("create dots");
801049be:	83 ec 0c             	sub    $0xc,%esp
801049c1:	68 6f 78 10 80       	push   $0x8010786f
801049c6:	e8 a5 b9 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801049cb:	83 ec 0c             	sub    $0xc,%esp
801049ce:	68 7e 78 10 80       	push   $0x8010787e
801049d3:	e8 98 b9 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	68 60 78 10 80       	push   $0x80107860
801049e0:	e8 8b b9 ff ff       	call   80100370 <panic>
801049e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049fa:	89 d3                	mov    %edx,%ebx
801049fc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049ff:	50                   	push   %eax
80104a00:	6a 00                	push   $0x0
80104a02:	e8 09 fd ff ff       	call   80104710 <argint>
80104a07:	83 c4 10             	add    $0x10,%esp
80104a0a:	85 c0                	test   %eax,%eax
80104a0c:	78 32                	js     80104a40 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a12:	77 2c                	ja     80104a40 <argfd.constprop.0+0x50>
80104a14:	e8 47 ed ff ff       	call   80103760 <myproc>
80104a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104a20:	85 c0                	test   %eax,%eax
80104a22:	74 1c                	je     80104a40 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104a24:	85 f6                	test   %esi,%esi
80104a26:	74 02                	je     80104a2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104a28:	89 16                	mov    %edx,(%esi)
  if(pf)
80104a2a:	85 db                	test   %ebx,%ebx
80104a2c:	74 22                	je     80104a50 <argfd.constprop.0+0x60>
    *pf = f;
80104a2e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104a30:	31 c0                	xor    %eax,%eax
}
80104a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104a48:	5b                   	pop    %ebx
80104a49:	5e                   	pop    %esi
80104a4a:	5d                   	pop    %ebp
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104a50:	31 c0                	xor    %eax,%eax
80104a52:	eb de                	jmp    80104a32 <argfd.constprop.0+0x42>
80104a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a60 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a60:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a61:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	56                   	push   %esi
80104a66:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a67:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104a6a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a6d:	e8 7e ff ff ff       	call   801049f0 <argfd.constprop.0>
80104a72:	85 c0                	test   %eax,%eax
80104a74:	78 1a                	js     80104a90 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a76:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a78:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104a7b:	e8 e0 ec ff ff       	call   80103760 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104a80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104a84:	85 d2                	test   %edx,%edx
80104a86:	74 18                	je     80104aa0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a88:	83 c3 01             	add    $0x1,%ebx
80104a8b:	83 fb 10             	cmp    $0x10,%ebx
80104a8e:	75 f0                	jne    80104a80 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a98:	5b                   	pop    %ebx
80104a99:	5e                   	pop    %esi
80104a9a:	5d                   	pop    %ebp
80104a9b:	c3                   	ret    
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104aa0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104aa4:	83 ec 0c             	sub    $0xc,%esp
80104aa7:	ff 75 f4             	pushl  -0xc(%ebp)
80104aaa:	e8 31 c3 ff ff       	call   80100de0 <filedup>
  return fd;
80104aaf:	83 c4 10             	add    $0x10,%esp
}
80104ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104ab5:	89 d8                	mov    %ebx,%eax
}
80104ab7:	5b                   	pop    %ebx
80104ab8:	5e                   	pop    %esi
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    
80104abb:	90                   	nop
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <sys_read>:

int
sys_read(void)
{
80104ac0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104acb:	e8 20 ff ff ff       	call   801049f0 <argfd.constprop.0>
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	78 4c                	js     80104b20 <sys_read+0x60>
80104ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ad7:	83 ec 08             	sub    $0x8,%esp
80104ada:	50                   	push   %eax
80104adb:	6a 02                	push   $0x2
80104add:	e8 2e fc ff ff       	call   80104710 <argint>
80104ae2:	83 c4 10             	add    $0x10,%esp
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	78 37                	js     80104b20 <sys_read+0x60>
80104ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aec:	83 ec 04             	sub    $0x4,%esp
80104aef:	ff 75 f0             	pushl  -0x10(%ebp)
80104af2:	50                   	push   %eax
80104af3:	6a 01                	push   $0x1
80104af5:	e8 46 fc ff ff       	call   80104740 <argptr>
80104afa:	83 c4 10             	add    $0x10,%esp
80104afd:	85 c0                	test   %eax,%eax
80104aff:	78 1f                	js     80104b20 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104b01:	83 ec 04             	sub    $0x4,%esp
80104b04:	ff 75 f0             	pushl  -0x10(%ebp)
80104b07:	ff 75 f4             	pushl  -0xc(%ebp)
80104b0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b0d:	e8 3e c4 ff ff       	call   80100f50 <fileread>
80104b12:	83 c4 10             	add    $0x10,%esp
}
80104b15:	c9                   	leave  
80104b16:	c3                   	ret    
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b25:	c9                   	leave  
80104b26:	c3                   	ret    
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <sys_write>:

int
sys_write(void)
{
80104b30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b31:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b3b:	e8 b0 fe ff ff       	call   801049f0 <argfd.constprop.0>
80104b40:	85 c0                	test   %eax,%eax
80104b42:	78 4c                	js     80104b90 <sys_write+0x60>
80104b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b47:	83 ec 08             	sub    $0x8,%esp
80104b4a:	50                   	push   %eax
80104b4b:	6a 02                	push   $0x2
80104b4d:	e8 be fb ff ff       	call   80104710 <argint>
80104b52:	83 c4 10             	add    $0x10,%esp
80104b55:	85 c0                	test   %eax,%eax
80104b57:	78 37                	js     80104b90 <sys_write+0x60>
80104b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b5c:	83 ec 04             	sub    $0x4,%esp
80104b5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b62:	50                   	push   %eax
80104b63:	6a 01                	push   $0x1
80104b65:	e8 d6 fb ff ff       	call   80104740 <argptr>
80104b6a:	83 c4 10             	add    $0x10,%esp
80104b6d:	85 c0                	test   %eax,%eax
80104b6f:	78 1f                	js     80104b90 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104b71:	83 ec 04             	sub    $0x4,%esp
80104b74:	ff 75 f0             	pushl  -0x10(%ebp)
80104b77:	ff 75 f4             	pushl  -0xc(%ebp)
80104b7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b7d:	e8 5e c4 ff ff       	call   80100fe0 <filewrite>
80104b82:	83 c4 10             	add    $0x10,%esp
}
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b95:	c9                   	leave  
80104b96:	c3                   	ret    
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <sys_close>:

int
sys_close(void)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104ba6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ba9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bac:	e8 3f fe ff ff       	call   801049f0 <argfd.constprop.0>
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	78 2b                	js     80104be0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104bb5:	e8 a6 eb ff ff       	call   80103760 <myproc>
80104bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104bbd:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104bc0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104bc7:	00 
  fileclose(f);
80104bc8:	ff 75 f4             	pushl  -0xc(%ebp)
80104bcb:	e8 60 c2 ff ff       	call   80100e30 <fileclose>
  return 0;
80104bd0:	83 c4 10             	add    $0x10,%esp
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <sys_fstat>:

int
sys_fstat(void)
{
80104bf0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104bf1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104bf3:	89 e5                	mov    %esp,%ebp
80104bf5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104bf8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104bfb:	e8 f0 fd ff ff       	call   801049f0 <argfd.constprop.0>
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 2c                	js     80104c30 <sys_fstat+0x40>
80104c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c07:	83 ec 04             	sub    $0x4,%esp
80104c0a:	6a 14                	push   $0x14
80104c0c:	50                   	push   %eax
80104c0d:	6a 01                	push   $0x1
80104c0f:	e8 2c fb ff ff       	call   80104740 <argptr>
80104c14:	83 c4 10             	add    $0x10,%esp
80104c17:	85 c0                	test   %eax,%eax
80104c19:	78 15                	js     80104c30 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104c1b:	83 ec 08             	sub    $0x8,%esp
80104c1e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c21:	ff 75 f0             	pushl  -0x10(%ebp)
80104c24:	e8 d7 c2 ff ff       	call   80100f00 <filestat>
80104c29:	83 c4 10             	add    $0x10,%esp
}
80104c2c:	c9                   	leave  
80104c2d:	c3                   	ret    
80104c2e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	56                   	push   %esi
80104c45:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c46:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c49:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c4c:	50                   	push   %eax
80104c4d:	6a 00                	push   $0x0
80104c4f:	e8 5c fb ff ff       	call   801047b0 <argstr>
80104c54:	83 c4 10             	add    $0x10,%esp
80104c57:	85 c0                	test   %eax,%eax
80104c59:	0f 88 fb 00 00 00    	js     80104d5a <sys_link+0x11a>
80104c5f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c62:	83 ec 08             	sub    $0x8,%esp
80104c65:	50                   	push   %eax
80104c66:	6a 01                	push   $0x1
80104c68:	e8 43 fb ff ff       	call   801047b0 <argstr>
80104c6d:	83 c4 10             	add    $0x10,%esp
80104c70:	85 c0                	test   %eax,%eax
80104c72:	0f 88 e2 00 00 00    	js     80104d5a <sys_link+0x11a>
    return -1;

  begin_op();
80104c78:	e8 c3 de ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
80104c7d:	83 ec 0c             	sub    $0xc,%esp
80104c80:	ff 75 d4             	pushl  -0x2c(%ebp)
80104c83:	e8 28 d2 ff ff       	call   80101eb0 <namei>
80104c88:	83 c4 10             	add    $0x10,%esp
80104c8b:	85 c0                	test   %eax,%eax
80104c8d:	89 c3                	mov    %eax,%ebx
80104c8f:	0f 84 f3 00 00 00    	je     80104d88 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104c95:	83 ec 0c             	sub    $0xc,%esp
80104c98:	50                   	push   %eax
80104c99:	e8 c2 c9 ff ff       	call   80101660 <ilock>
  if(ip->type == T_DIR){
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ca6:	0f 84 c4 00 00 00    	je     80104d70 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104cac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cb1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104cb4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104cb7:	53                   	push   %ebx
80104cb8:	e8 f3 c8 ff ff       	call   801015b0 <iupdate>
  iunlock(ip);
80104cbd:	89 1c 24             	mov    %ebx,(%esp)
80104cc0:	e8 7b ca ff ff       	call   80101740 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104cc5:	58                   	pop    %eax
80104cc6:	5a                   	pop    %edx
80104cc7:	57                   	push   %edi
80104cc8:	ff 75 d0             	pushl  -0x30(%ebp)
80104ccb:	e8 00 d2 ff ff       	call   80101ed0 <nameiparent>
80104cd0:	83 c4 10             	add    $0x10,%esp
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	89 c6                	mov    %eax,%esi
80104cd7:	74 5b                	je     80104d34 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104cd9:	83 ec 0c             	sub    $0xc,%esp
80104cdc:	50                   	push   %eax
80104cdd:	e8 7e c9 ff ff       	call   80101660 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ce2:	83 c4 10             	add    $0x10,%esp
80104ce5:	8b 03                	mov    (%ebx),%eax
80104ce7:	39 06                	cmp    %eax,(%esi)
80104ce9:	75 3d                	jne    80104d28 <sys_link+0xe8>
80104ceb:	83 ec 04             	sub    $0x4,%esp
80104cee:	ff 73 04             	pushl  0x4(%ebx)
80104cf1:	57                   	push   %edi
80104cf2:	56                   	push   %esi
80104cf3:	e8 f8 d0 ff ff       	call   80101df0 <dirlink>
80104cf8:	83 c4 10             	add    $0x10,%esp
80104cfb:	85 c0                	test   %eax,%eax
80104cfd:	78 29                	js     80104d28 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104cff:	83 ec 0c             	sub    $0xc,%esp
80104d02:	56                   	push   %esi
80104d03:	e8 e8 cb ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104d08:	89 1c 24             	mov    %ebx,(%esp)
80104d0b:	e8 80 ca ff ff       	call   80101790 <iput>

  end_op();
80104d10:	e8 9b de ff ff       	call   80102bb0 <end_op>

  return 0;
80104d15:	83 c4 10             	add    $0x10,%esp
80104d18:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d1d:	5b                   	pop    %ebx
80104d1e:	5e                   	pop    %esi
80104d1f:	5f                   	pop    %edi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    
80104d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104d28:	83 ec 0c             	sub    $0xc,%esp
80104d2b:	56                   	push   %esi
80104d2c:	e8 bf cb ff ff       	call   801018f0 <iunlockput>
    goto bad;
80104d31:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	53                   	push   %ebx
80104d38:	e8 23 c9 ff ff       	call   80101660 <ilock>
  ip->nlink--;
80104d3d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d42:	89 1c 24             	mov    %ebx,(%esp)
80104d45:	e8 66 c8 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104d4a:	89 1c 24             	mov    %ebx,(%esp)
80104d4d:	e8 9e cb ff ff       	call   801018f0 <iunlockput>
  end_op();
80104d52:	e8 59 de ff ff       	call   80102bb0 <end_op>
  return -1;
80104d57:	83 c4 10             	add    $0x10,%esp
}
80104d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d62:	5b                   	pop    %ebx
80104d63:	5e                   	pop    %esi
80104d64:	5f                   	pop    %edi
80104d65:	5d                   	pop    %ebp
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	53                   	push   %ebx
80104d74:	e8 77 cb ff ff       	call   801018f0 <iunlockput>
    end_op();
80104d79:	e8 32 de ff ff       	call   80102bb0 <end_op>
    return -1;
80104d7e:	83 c4 10             	add    $0x10,%esp
80104d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d86:	eb 92                	jmp    80104d1a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104d88:	e8 23 de ff ff       	call   80102bb0 <end_op>
    return -1;
80104d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d92:	eb 86                	jmp    80104d1a <sys_link+0xda>
80104d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104da0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104da6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104da9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104dac:	50                   	push   %eax
80104dad:	6a 00                	push   $0x0
80104daf:	e8 fc f9 ff ff       	call   801047b0 <argstr>
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 c0                	test   %eax,%eax
80104db9:	0f 88 82 01 00 00    	js     80104f41 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104dbf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104dc2:	e8 79 dd ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104dc7:	83 ec 08             	sub    $0x8,%esp
80104dca:	53                   	push   %ebx
80104dcb:	ff 75 c0             	pushl  -0x40(%ebp)
80104dce:	e8 fd d0 ff ff       	call   80101ed0 <nameiparent>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104ddb:	0f 84 6a 01 00 00    	je     80104f4b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104de1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	56                   	push   %esi
80104de8:	e8 73 c8 ff ff       	call   80101660 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ded:	58                   	pop    %eax
80104dee:	5a                   	pop    %edx
80104def:	68 7c 78 10 80       	push   $0x8010787c
80104df4:	53                   	push   %ebx
80104df5:	e8 76 cd ff ff       	call   80101b70 <namecmp>
80104dfa:	83 c4 10             	add    $0x10,%esp
80104dfd:	85 c0                	test   %eax,%eax
80104dff:	0f 84 fc 00 00 00    	je     80104f01 <sys_unlink+0x161>
80104e05:	83 ec 08             	sub    $0x8,%esp
80104e08:	68 7b 78 10 80       	push   $0x8010787b
80104e0d:	53                   	push   %ebx
80104e0e:	e8 5d cd ff ff       	call   80101b70 <namecmp>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	0f 84 e3 00 00 00    	je     80104f01 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e1e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e21:	83 ec 04             	sub    $0x4,%esp
80104e24:	50                   	push   %eax
80104e25:	53                   	push   %ebx
80104e26:	56                   	push   %esi
80104e27:	e8 64 cd ff ff       	call   80101b90 <dirlookup>
80104e2c:	83 c4 10             	add    $0x10,%esp
80104e2f:	85 c0                	test   %eax,%eax
80104e31:	89 c3                	mov    %eax,%ebx
80104e33:	0f 84 c8 00 00 00    	je     80104f01 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104e39:	83 ec 0c             	sub    $0xc,%esp
80104e3c:	50                   	push   %eax
80104e3d:	e8 1e c8 ff ff       	call   80101660 <ilock>

  if(ip->nlink < 1)
80104e42:	83 c4 10             	add    $0x10,%esp
80104e45:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104e4a:	0f 8e 24 01 00 00    	jle    80104f74 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e55:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e58:	74 66                	je     80104ec0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104e5a:	83 ec 04             	sub    $0x4,%esp
80104e5d:	6a 10                	push   $0x10
80104e5f:	6a 00                	push   $0x0
80104e61:	56                   	push   %esi
80104e62:	e8 99 f5 ff ff       	call   80104400 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e67:	6a 10                	push   $0x10
80104e69:	ff 75 c4             	pushl  -0x3c(%ebp)
80104e6c:	56                   	push   %esi
80104e6d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e70:	e8 cb cb ff ff       	call   80101a40 <writei>
80104e75:	83 c4 20             	add    $0x20,%esp
80104e78:	83 f8 10             	cmp    $0x10,%eax
80104e7b:	0f 85 e6 00 00 00    	jne    80104f67 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e86:	0f 84 9c 00 00 00    	je     80104f28 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e92:	e8 59 ca ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80104e97:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e9c:	89 1c 24             	mov    %ebx,(%esp)
80104e9f:	e8 0c c7 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104ea4:	89 1c 24             	mov    %ebx,(%esp)
80104ea7:	e8 44 ca ff ff       	call   801018f0 <iunlockput>

  end_op();
80104eac:	e8 ff dc ff ff       	call   80102bb0 <end_op>

  return 0;
80104eb1:	83 c4 10             	add    $0x10,%esp
80104eb4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5f                   	pop    %edi
80104ebc:	5d                   	pop    %ebp
80104ebd:	c3                   	ret    
80104ebe:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ec0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104ec4:	76 94                	jbe    80104e5a <sys_unlink+0xba>
80104ec6:	bf 20 00 00 00       	mov    $0x20,%edi
80104ecb:	eb 0f                	jmp    80104edc <sys_unlink+0x13c>
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	83 c7 10             	add    $0x10,%edi
80104ed3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104ed6:	0f 83 7e ff ff ff    	jae    80104e5a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104edc:	6a 10                	push   $0x10
80104ede:	57                   	push   %edi
80104edf:	56                   	push   %esi
80104ee0:	53                   	push   %ebx
80104ee1:	e8 5a ca ff ff       	call   80101940 <readi>
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	83 f8 10             	cmp    $0x10,%eax
80104eec:	75 6c                	jne    80104f5a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104eee:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ef3:	74 db                	je     80104ed0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ef5:	83 ec 0c             	sub    $0xc,%esp
80104ef8:	53                   	push   %ebx
80104ef9:	e8 f2 c9 ff ff       	call   801018f0 <iunlockput>
    goto bad;
80104efe:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f01:	83 ec 0c             	sub    $0xc,%esp
80104f04:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f07:	e8 e4 c9 ff ff       	call   801018f0 <iunlockput>
  end_op();
80104f0c:	e8 9f dc ff ff       	call   80102bb0 <end_op>
  return -1;
80104f11:	83 c4 10             	add    $0x10,%esp
}
80104f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f1c:	5b                   	pop    %ebx
80104f1d:	5e                   	pop    %esi
80104f1e:	5f                   	pop    %edi
80104f1f:	5d                   	pop    %ebp
80104f20:	c3                   	ret    
80104f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104f2b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f2e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f33:	50                   	push   %eax
80104f34:	e8 77 c6 ff ff       	call   801015b0 <iupdate>
80104f39:	83 c4 10             	add    $0x10,%esp
80104f3c:	e9 4b ff ff ff       	jmp    80104e8c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f46:	e9 6b ff ff ff       	jmp    80104eb6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104f4b:	e8 60 dc ff ff       	call   80102bb0 <end_op>
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f55:	e9 5c ff ff ff       	jmp    80104eb6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104f5a:	83 ec 0c             	sub    $0xc,%esp
80104f5d:	68 a0 78 10 80       	push   $0x801078a0
80104f62:	e8 09 b4 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104f67:	83 ec 0c             	sub    $0xc,%esp
80104f6a:	68 b2 78 10 80       	push   $0x801078b2
80104f6f:	e8 fc b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	68 8e 78 10 80       	push   $0x8010788e
80104f7c:	e8 ef b3 ff ff       	call   80100370 <panic>
80104f81:	eb 0d                	jmp    80104f90 <sys_open>
80104f83:	90                   	nop
80104f84:	90                   	nop
80104f85:	90                   	nop
80104f86:	90                   	nop
80104f87:	90                   	nop
80104f88:	90                   	nop
80104f89:	90                   	nop
80104f8a:	90                   	nop
80104f8b:	90                   	nop
80104f8c:	90                   	nop
80104f8d:	90                   	nop
80104f8e:	90                   	nop
80104f8f:	90                   	nop

80104f90 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f96:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104f99:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f9c:	50                   	push   %eax
80104f9d:	6a 00                	push   $0x0
80104f9f:	e8 0c f8 ff ff       	call   801047b0 <argstr>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	0f 88 9e 00 00 00    	js     8010504d <sys_open+0xbd>
80104faf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104fb2:	83 ec 08             	sub    $0x8,%esp
80104fb5:	50                   	push   %eax
80104fb6:	6a 01                	push   $0x1
80104fb8:	e8 53 f7 ff ff       	call   80104710 <argint>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	0f 88 85 00 00 00    	js     8010504d <sys_open+0xbd>
    return -1;

  begin_op();
80104fc8:	e8 73 db ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
80104fcd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104fd1:	0f 85 89 00 00 00    	jne    80105060 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104fd7:	83 ec 0c             	sub    $0xc,%esp
80104fda:	ff 75 e0             	pushl  -0x20(%ebp)
80104fdd:	e8 ce ce ff ff       	call   80101eb0 <namei>
80104fe2:	83 c4 10             	add    $0x10,%esp
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	89 c6                	mov    %eax,%esi
80104fe9:	0f 84 8e 00 00 00    	je     8010507d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80104fef:	83 ec 0c             	sub    $0xc,%esp
80104ff2:	50                   	push   %eax
80104ff3:	e8 68 c6 ff ff       	call   80101660 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105000:	0f 84 d2 00 00 00    	je     801050d8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105006:	e8 65 bd ff ff       	call   80100d70 <filealloc>
8010500b:	85 c0                	test   %eax,%eax
8010500d:	89 c7                	mov    %eax,%edi
8010500f:	74 2b                	je     8010503c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105011:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105013:	e8 48 e7 ff ff       	call   80103760 <myproc>
80105018:	90                   	nop
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105020:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105024:	85 d2                	test   %edx,%edx
80105026:	74 68                	je     80105090 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105028:	83 c3 01             	add    $0x1,%ebx
8010502b:	83 fb 10             	cmp    $0x10,%ebx
8010502e:	75 f0                	jne    80105020 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105030:	83 ec 0c             	sub    $0xc,%esp
80105033:	57                   	push   %edi
80105034:	e8 f7 bd ff ff       	call   80100e30 <fileclose>
80105039:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	56                   	push   %esi
80105040:	e8 ab c8 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105045:	e8 66 db ff ff       	call   80102bb0 <end_op>
    return -1;
8010504a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010504d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5f                   	pop    %edi
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret    
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105060:	83 ec 0c             	sub    $0xc,%esp
80105063:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105066:	31 c9                	xor    %ecx,%ecx
80105068:	6a 00                	push   $0x0
8010506a:	ba 02 00 00 00       	mov    $0x2,%edx
8010506f:	e8 dc f7 ff ff       	call   80104850 <create>
    if(ip == 0){
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105079:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010507b:	75 89                	jne    80105006 <sys_open+0x76>
      end_op();
8010507d:	e8 2e db ff ff       	call   80102bb0 <end_op>
      return -1;
80105082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105087:	eb 43                	jmp    801050cc <sys_open+0x13c>
80105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105090:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105093:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105097:	56                   	push   %esi
80105098:	e8 a3 c6 ff ff       	call   80101740 <iunlock>
  end_op();
8010509d:	e8 0e db ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
801050a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801050a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050ab:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801050ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801050b1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801050b8:	89 d0                	mov    %edx,%eax
801050ba:	83 e0 01             	and    $0x1,%eax
801050bd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050c0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801050c3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050c6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801050ca:	89 d8                	mov    %ebx,%eax
}
801050cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5f                   	pop    %edi
801050d2:	5d                   	pop    %ebp
801050d3:	c3                   	ret    
801050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801050d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801050db:	85 c9                	test   %ecx,%ecx
801050dd:	0f 84 23 ff ff ff    	je     80105006 <sys_open+0x76>
801050e3:	e9 54 ff ff ff       	jmp    8010503c <sys_open+0xac>
801050e8:	90                   	nop
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050f0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050f6:	e8 45 da ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801050fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050fe:	83 ec 08             	sub    $0x8,%esp
80105101:	50                   	push   %eax
80105102:	6a 00                	push   $0x0
80105104:	e8 a7 f6 ff ff       	call   801047b0 <argstr>
80105109:	83 c4 10             	add    $0x10,%esp
8010510c:	85 c0                	test   %eax,%eax
8010510e:	78 30                	js     80105140 <sys_mkdir+0x50>
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105116:	31 c9                	xor    %ecx,%ecx
80105118:	6a 00                	push   $0x0
8010511a:	ba 01 00 00 00       	mov    $0x1,%edx
8010511f:	e8 2c f7 ff ff       	call   80104850 <create>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
80105129:	74 15                	je     80105140 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010512b:	83 ec 0c             	sub    $0xc,%esp
8010512e:	50                   	push   %eax
8010512f:	e8 bc c7 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105134:	e8 77 da ff ff       	call   80102bb0 <end_op>
  return 0;
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	31 c0                	xor    %eax,%eax
}
8010513e:	c9                   	leave  
8010513f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105140:	e8 6b da ff ff       	call   80102bb0 <end_op>
    return -1;
80105145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010514a:	c9                   	leave  
8010514b:	c3                   	ret    
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105150 <sys_mknod>:

int
sys_mknod(void)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105156:	e8 e5 d9 ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010515b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010515e:	83 ec 08             	sub    $0x8,%esp
80105161:	50                   	push   %eax
80105162:	6a 00                	push   $0x0
80105164:	e8 47 f6 ff ff       	call   801047b0 <argstr>
80105169:	83 c4 10             	add    $0x10,%esp
8010516c:	85 c0                	test   %eax,%eax
8010516e:	78 60                	js     801051d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105170:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105173:	83 ec 08             	sub    $0x8,%esp
80105176:	50                   	push   %eax
80105177:	6a 01                	push   $0x1
80105179:	e8 92 f5 ff ff       	call   80104710 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	85 c0                	test   %eax,%eax
80105183:	78 4b                	js     801051d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105185:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105188:	83 ec 08             	sub    $0x8,%esp
8010518b:	50                   	push   %eax
8010518c:	6a 02                	push   $0x2
8010518e:	e8 7d f5 ff ff       	call   80104710 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	78 36                	js     801051d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010519a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801051a5:	ba 03 00 00 00       	mov    $0x3,%edx
801051aa:	50                   	push   %eax
801051ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051ae:	e8 9d f6 ff ff       	call   80104850 <create>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	74 16                	je     801051d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	50                   	push   %eax
801051be:	e8 2d c7 ff ff       	call   801018f0 <iunlockput>
  end_op();
801051c3:	e8 e8 d9 ff ff       	call   80102bb0 <end_op>
  return 0;
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	31 c0                	xor    %eax,%eax
}
801051cd:	c9                   	leave  
801051ce:	c3                   	ret    
801051cf:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801051d0:	e8 db d9 ff ff       	call   80102bb0 <end_op>
    return -1;
801051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051da:	c9                   	leave  
801051db:	c3                   	ret    
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_chdir>:

int
sys_chdir(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
801051e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801051e8:	e8 73 e5 ff ff       	call   80103760 <myproc>
801051ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801051ef:	e8 4c d9 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801051f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f7:	83 ec 08             	sub    $0x8,%esp
801051fa:	50                   	push   %eax
801051fb:	6a 00                	push   $0x0
801051fd:	e8 ae f5 ff ff       	call   801047b0 <argstr>
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	85 c0                	test   %eax,%eax
80105207:	78 77                	js     80105280 <sys_chdir+0xa0>
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	ff 75 f4             	pushl  -0xc(%ebp)
8010520f:	e8 9c cc ff ff       	call   80101eb0 <namei>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	89 c3                	mov    %eax,%ebx
8010521b:	74 63                	je     80105280 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010521d:	83 ec 0c             	sub    $0xc,%esp
80105220:	50                   	push   %eax
80105221:	e8 3a c4 ff ff       	call   80101660 <ilock>
  if(ip->type != T_DIR){
80105226:	83 c4 10             	add    $0x10,%esp
80105229:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010522e:	75 30                	jne    80105260 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105230:	83 ec 0c             	sub    $0xc,%esp
80105233:	53                   	push   %ebx
80105234:	e8 07 c5 ff ff       	call   80101740 <iunlock>
  iput(curproc->cwd);
80105239:	58                   	pop    %eax
8010523a:	ff 76 68             	pushl  0x68(%esi)
8010523d:	e8 4e c5 ff ff       	call   80101790 <iput>
  end_op();
80105242:	e8 69 d9 ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
80105247:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	31 c0                	xor    %eax,%eax
}
8010524f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105252:	5b                   	pop    %ebx
80105253:	5e                   	pop    %esi
80105254:	5d                   	pop    %ebp
80105255:	c3                   	ret    
80105256:	8d 76 00             	lea    0x0(%esi),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	53                   	push   %ebx
80105264:	e8 87 c6 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105269:	e8 42 d9 ff ff       	call   80102bb0 <end_op>
    return -1;
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105276:	eb d7                	jmp    8010524f <sys_chdir+0x6f>
80105278:	90                   	nop
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105280:	e8 2b d9 ff ff       	call   80102bb0 <end_op>
    return -1;
80105285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528a:	eb c3                	jmp    8010524f <sys_chdir+0x6f>
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
80105295:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105296:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010529c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801052a2:	50                   	push   %eax
801052a3:	6a 00                	push   $0x0
801052a5:	e8 06 f5 ff ff       	call   801047b0 <argstr>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	85 c0                	test   %eax,%eax
801052af:	78 7f                	js     80105330 <sys_exec+0xa0>
801052b1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801052b7:	83 ec 08             	sub    $0x8,%esp
801052ba:	50                   	push   %eax
801052bb:	6a 01                	push   $0x1
801052bd:	e8 4e f4 ff ff       	call   80104710 <argint>
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	85 c0                	test   %eax,%eax
801052c7:	78 67                	js     80105330 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052c9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052cf:	83 ec 04             	sub    $0x4,%esp
801052d2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801052d8:	68 80 00 00 00       	push   $0x80
801052dd:	6a 00                	push   $0x0
801052df:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801052e5:	50                   	push   %eax
801052e6:	31 db                	xor    %ebx,%ebx
801052e8:	e8 13 f1 ff ff       	call   80104400 <memset>
801052ed:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801052f0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801052f6:	83 ec 08             	sub    $0x8,%esp
801052f9:	57                   	push   %edi
801052fa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801052fd:	50                   	push   %eax
801052fe:	e8 6d f3 ff ff       	call   80104670 <fetchint>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	78 26                	js     80105330 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010530a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105310:	85 c0                	test   %eax,%eax
80105312:	74 2c                	je     80105340 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105314:	83 ec 08             	sub    $0x8,%esp
80105317:	56                   	push   %esi
80105318:	50                   	push   %eax
80105319:	e8 92 f3 ff ff       	call   801046b0 <fetchstr>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	78 0b                	js     80105330 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105325:	83 c3 01             	add    $0x1,%ebx
80105328:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010532b:	83 fb 20             	cmp    $0x20,%ebx
8010532e:	75 c0                	jne    801052f0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105338:	5b                   	pop    %ebx
80105339:	5e                   	pop    %esi
8010533a:	5f                   	pop    %edi
8010533b:	5d                   	pop    %ebp
8010533c:	c3                   	ret    
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105340:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105346:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105349:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105350:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105354:	50                   	push   %eax
80105355:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010535b:	e8 90 b6 ff ff       	call   801009f0 <exec>
80105360:	83 c4 10             	add    $0x10,%esp
}
80105363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105366:	5b                   	pop    %ebx
80105367:	5e                   	pop    %esi
80105368:	5f                   	pop    %edi
80105369:	5d                   	pop    %ebp
8010536a:	c3                   	ret    
8010536b:	90                   	nop
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_pipe>:

int
sys_pipe(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105376:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105379:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010537c:	6a 08                	push   $0x8
8010537e:	50                   	push   %eax
8010537f:	6a 00                	push   $0x0
80105381:	e8 ba f3 ff ff       	call   80104740 <argptr>
80105386:	83 c4 10             	add    $0x10,%esp
80105389:	85 c0                	test   %eax,%eax
8010538b:	78 4a                	js     801053d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010538d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105390:	83 ec 08             	sub    $0x8,%esp
80105393:	50                   	push   %eax
80105394:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105397:	50                   	push   %eax
80105398:	e8 43 de ff ff       	call   801031e0 <pipealloc>
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	85 c0                	test   %eax,%eax
801053a2:	78 33                	js     801053d7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053a4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801053a6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801053a9:	e8 b2 e3 ff ff       	call   80103760 <myproc>
801053ae:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801053b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801053b4:	85 f6                	test   %esi,%esi
801053b6:	74 30                	je     801053e8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053b8:	83 c3 01             	add    $0x1,%ebx
801053bb:	83 fb 10             	cmp    $0x10,%ebx
801053be:	75 f0                	jne    801053b0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	ff 75 e0             	pushl  -0x20(%ebp)
801053c6:	e8 65 ba ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801053cb:	58                   	pop    %eax
801053cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801053cf:	e8 5c ba ff ff       	call   80100e30 <fileclose>
    return -1;
801053d4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801053da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053df:	5b                   	pop    %ebx
801053e0:	5e                   	pop    %esi
801053e1:	5f                   	pop    %edi
801053e2:	5d                   	pop    %ebp
801053e3:	c3                   	ret    
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801053e8:	8d 73 08             	lea    0x8(%ebx),%esi
801053eb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801053ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801053f2:	e8 69 e3 ff ff       	call   80103760 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801053f7:	31 d2                	xor    %edx,%edx
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105400:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105404:	85 c9                	test   %ecx,%ecx
80105406:	74 18                	je     80105420 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105408:	83 c2 01             	add    $0x1,%edx
8010540b:	83 fa 10             	cmp    $0x10,%edx
8010540e:	75 f0                	jne    80105400 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105410:	e8 4b e3 ff ff       	call   80103760 <myproc>
80105415:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010541c:	00 
8010541d:	eb a1                	jmp    801053c0 <sys_pipe+0x50>
8010541f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105420:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105424:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105427:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105429:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010542c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010542f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105432:	31 c0                	xor    %eax,%eax
}
80105434:	5b                   	pop    %ebx
80105435:	5e                   	pop    %esi
80105436:	5f                   	pop    %edi
80105437:	5d                   	pop    %ebp
80105438:	c3                   	ret    
80105439:	66 90                	xchg   %ax,%ax
8010543b:	66 90                	xchg   %ax,%ax
8010543d:	66 90                	xchg   %ax,%ax
8010543f:	90                   	nop

80105440 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105443:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105444:	e9 b7 e4 ff ff       	jmp    80103900 <fork>
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_exit>:
}

int
sys_exit(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 08             	sub    $0x8,%esp
  exit();
80105456:	e8 35 e7 ff ff       	call   80103b90 <exit>
  return 0;  // not reached
}
8010545b:	31 c0                	xor    %eax,%eax
8010545d:	c9                   	leave  
8010545e:	c3                   	ret    
8010545f:	90                   	nop

80105460 <sys_wait>:

int
sys_wait(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105463:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105464:	e9 67 e9 ff ff       	jmp    80103dd0 <wait>
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_kill>:
}

int
sys_kill(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105476:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105479:	50                   	push   %eax
8010547a:	6a 00                	push   $0x0
8010547c:	e8 8f f2 ff ff       	call   80104710 <argint>
80105481:	83 c4 10             	add    $0x10,%esp
80105484:	85 c0                	test   %eax,%eax
80105486:	78 18                	js     801054a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	ff 75 f4             	pushl  -0xc(%ebp)
8010548e:	e8 8d ea ff ff       	call   80103f20 <kill>
80105493:	83 c4 10             	add    $0x10,%esp
}
80105496:	c9                   	leave  
80105497:	c3                   	ret    
80105498:	90                   	nop
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_getpid>:

int
sys_getpid(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801054b6:	e8 a5 e2 ff ff       	call   80103760 <myproc>
801054bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801054be:	c9                   	leave  
801054bf:	c3                   	ret    

801054c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801054c7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054ca:	50                   	push   %eax
801054cb:	6a 00                	push   $0x0
801054cd:	e8 3e f2 ff ff       	call   80104710 <argint>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 27                	js     80105500 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801054d9:	e8 82 e2 ff ff       	call   80103760 <myproc>
  if(growproc(n) < 0)
801054de:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801054e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801054e3:	ff 75 f4             	pushl  -0xc(%ebp)
801054e6:	e8 95 e3 ff ff       	call   80103880 <growproc>
801054eb:	83 c4 10             	add    $0x10,%esp
801054ee:	85 c0                	test   %eax,%eax
801054f0:	78 0e                	js     80105500 <sys_sbrk+0x40>
    return -1;
  return addr;
801054f2:	89 d8                	mov    %ebx,%eax
}
801054f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054f7:	c9                   	leave  
801054f8:	c3                   	ret    
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb ed                	jmp    801054f4 <sys_sbrk+0x34>
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <sys_mprotect>:
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}
int sys_mprotect(void){
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 20             	sub    $0x20,%esp
  int d;
  int n = 0;
  if(argint(0, &d)<0 || argint(1, &n)<0){
80105516:	8d 45 f0             	lea    -0x10(%ebp),%eax
    return -1;
  return addr;
}
int sys_mprotect(void){
  int d;
  int n = 0;
80105519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argint(0, &d)<0 || argint(1, &n)<0){
80105520:	50                   	push   %eax
80105521:	6a 00                	push   $0x0
80105523:	e8 e8 f1 ff ff       	call   80104710 <argint>
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	85 c0                	test   %eax,%eax
8010552d:	78 31                	js     80105560 <sys_mprotect+0x50>
8010552f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105532:	83 ec 08             	sub    $0x8,%esp
80105535:	50                   	push   %eax
80105536:	6a 01                	push   $0x1
80105538:	e8 d3 f1 ff ff       	call   80104710 <argint>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 1c                	js     80105560 <sys_mprotect+0x50>
    return -1;
  }
  return mprotect((void *)d,n);
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	ff 75 f4             	pushl  -0xc(%ebp)
8010554a:	ff 75 f0             	pushl  -0x10(%ebp)
8010554d:	e8 0e 1a 00 00       	call   80106f60 <mprotect>
80105552:	83 c4 10             	add    $0x10,%esp

}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
int sys_mprotect(void){
  int d;
  int n = 0;
  if(argint(0, &d)<0 || argint(1, &n)<0){
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return mprotect((void *)d,n);

}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <sys_munprotect>:

int sys_munprotect(void){
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 20             	sub    $0x20,%esp
  int d;
  int n = 0;
  if(argint(0, &d)<0 || argint(1, &n)<0){
80105576:	8d 45 f0             	lea    -0x10(%ebp),%eax

}

int sys_munprotect(void){
  int d;
  int n = 0;
80105579:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argint(0, &d)<0 || argint(1, &n)<0){
80105580:	50                   	push   %eax
80105581:	6a 00                	push   $0x0
80105583:	e8 88 f1 ff ff       	call   80104710 <argint>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	78 31                	js     801055c0 <sys_munprotect+0x50>
8010558f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105592:	83 ec 08             	sub    $0x8,%esp
80105595:	50                   	push   %eax
80105596:	6a 01                	push   $0x1
80105598:	e8 73 f1 ff ff       	call   80104710 <argint>
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	85 c0                	test   %eax,%eax
801055a2:	78 1c                	js     801055c0 <sys_munprotect+0x50>
    return -1;
  }
  return munprotect((void *)d,n);
801055a4:	83 ec 08             	sub    $0x8,%esp
801055a7:	ff 75 f4             	pushl  -0xc(%ebp)
801055aa:	ff 75 f0             	pushl  -0x10(%ebp)
801055ad:	e8 8e 1a 00 00       	call   80107040 <munprotect>
801055b2:	83 c4 10             	add    $0x10,%esp

}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

int sys_munprotect(void){
  int d;
  int n = 0;
  if(argint(0, &d)<0 || argint(1, &n)<0){
    return -1;
801055c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return munprotect((void *)d,n);

}
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_sleep>:

int
sys_sleep(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	53                   	push   %ebx
  int n;
  uint ticks0;
  if(argint(0, &n) < 0)
801055d4:	8d 45 f4             	lea    -0xc(%ebp),%eax

}

int
sys_sleep(void)
{
801055d7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;
  if(argint(0, &n) < 0)
801055da:	50                   	push   %eax
801055db:	6a 00                	push   $0x0
801055dd:	e8 2e f1 ff ff       	call   80104710 <argint>
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	85 c0                	test   %eax,%eax
801055e7:	0f 88 8a 00 00 00    	js     80105677 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055ed:	83 ec 0c             	sub    $0xc,%esp
801055f0:	68 60 4c 11 80       	push   $0x80114c60
801055f5:	e8 06 ed ff ff       	call   80104300 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055fd:	83 c4 10             	add    $0x10,%esp
  int n;
  uint ticks0;
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105600:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105606:	85 d2                	test   %edx,%edx
80105608:	75 27                	jne    80105631 <sys_sleep+0x61>
8010560a:	eb 54                	jmp    80105660 <sys_sleep+0x90>
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105610:	83 ec 08             	sub    $0x8,%esp
80105613:	68 60 4c 11 80       	push   $0x80114c60
80105618:	68 a0 54 11 80       	push   $0x801154a0
8010561d:	e8 ee e6 ff ff       	call   80103d10 <sleep>
  uint ticks0;
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105622:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105627:	83 c4 10             	add    $0x10,%esp
8010562a:	29 d8                	sub    %ebx,%eax
8010562c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010562f:	73 2f                	jae    80105660 <sys_sleep+0x90>
    if(myproc()->killed){
80105631:	e8 2a e1 ff ff       	call   80103760 <myproc>
80105636:	8b 40 24             	mov    0x24(%eax),%eax
80105639:	85 c0                	test   %eax,%eax
8010563b:	74 d3                	je     80105610 <sys_sleep+0x40>
      release(&tickslock);
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	68 60 4c 11 80       	push   $0x80114c60
80105645:	e8 66 ed ff ff       	call   801043b0 <release>
      return -1;
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	68 60 4c 11 80       	push   $0x80114c60
80105668:	e8 43 ed ff ff       	call   801043b0 <release>
  return 0;
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	31 c0                	xor    %eax,%eax
}
80105672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105675:	c9                   	leave  
80105676:	c3                   	ret    
sys_sleep(void)
{
  int n;
  uint ticks0;
  if(argint(0, &n) < 0)
    return -1;
80105677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567c:	eb d4                	jmp    80105652 <sys_sleep+0x82>
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
80105684:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105687:	68 60 4c 11 80       	push   $0x80114c60
8010568c:	e8 6f ec ff ff       	call   80104300 <acquire>
  xticks = ticks;
80105691:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105697:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010569e:	e8 0d ed ff ff       	call   801043b0 <release>
  return xticks;
}
801056a3:	89 d8                	mov    %ebx,%eax
801056a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a8:	c9                   	leave  
801056a9:	c3                   	ret    

801056aa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801056aa:	1e                   	push   %ds
  pushl %es
801056ab:	06                   	push   %es
  pushl %fs
801056ac:	0f a0                	push   %fs
  pushl %gs
801056ae:	0f a8                	push   %gs
  pushal
801056b0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801056b1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801056b5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801056b7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801056b9:	54                   	push   %esp
  call trap
801056ba:	e8 e1 00 00 00       	call   801057a0 <trap>
  addl $4, %esp
801056bf:	83 c4 04             	add    $0x4,%esp

801056c2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056c2:	61                   	popa   
  popl %gs
801056c3:	0f a9                	pop    %gs
  popl %fs
801056c5:	0f a1                	pop    %fs
  popl %es
801056c7:	07                   	pop    %es
  popl %ds
801056c8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056c9:	83 c4 08             	add    $0x8,%esp
  iret
801056cc:	cf                   	iret   
801056cd:	66 90                	xchg   %ax,%ax
801056cf:	90                   	nop

801056d0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056d0:	31 c0                	xor    %eax,%eax
801056d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056d8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801056df:	b9 08 00 00 00       	mov    $0x8,%ecx
801056e4:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
801056eb:	00 
801056ec:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
801056f3:	80 
801056f4:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
801056fb:	8e 
801056fc:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105703:	80 
80105704:	c1 ea 10             	shr    $0x10,%edx
80105707:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
8010570e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010570f:	83 c0 01             	add    $0x1,%eax
80105712:	3d 00 01 00 00       	cmp    $0x100,%eax
80105717:	75 bf                	jne    801056d8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105719:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010571a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010571f:	89 e5                	mov    %esp,%ebp
80105721:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105724:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105729:	68 c1 78 10 80       	push   $0x801078c1
8010572e:	68 60 4c 11 80       	push   $0x80114c60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105733:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
8010573a:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
80105741:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105747:	c1 e8 10             	shr    $0x10,%eax
8010574a:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105751:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6

  initlock(&tickslock, "time");
80105757:	e8 44 ea ff ff       	call   801041a0 <initlock>
}
8010575c:	83 c4 10             	add    $0x10,%esp
8010575f:	c9                   	leave  
80105760:	c3                   	ret    
80105761:	eb 0d                	jmp    80105770 <idtinit>
80105763:	90                   	nop
80105764:	90                   	nop
80105765:	90                   	nop
80105766:	90                   	nop
80105767:	90                   	nop
80105768:	90                   	nop
80105769:	90                   	nop
8010576a:	90                   	nop
8010576b:	90                   	nop
8010576c:	90                   	nop
8010576d:	90                   	nop
8010576e:	90                   	nop
8010576f:	90                   	nop

80105770 <idtinit>:

void
idtinit(void)
{
80105770:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105771:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105776:	89 e5                	mov    %esp,%ebp
80105778:	83 ec 10             	sub    $0x10,%esp
8010577b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010577f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105784:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105788:	c1 e8 10             	shr    $0x10,%eax
8010578b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010578f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105792:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105795:	c9                   	leave  
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
801057a5:	53                   	push   %ebx
801057a6:	83 ec 1c             	sub    $0x1c,%esp
801057a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801057ac:	8b 47 30             	mov    0x30(%edi),%eax
801057af:	83 f8 40             	cmp    $0x40,%eax
801057b2:	0f 84 88 01 00 00    	je     80105940 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801057b8:	83 e8 20             	sub    $0x20,%eax
801057bb:	83 f8 1f             	cmp    $0x1f,%eax
801057be:	77 10                	ja     801057d0 <trap+0x30>
801057c0:	ff 24 85 68 79 10 80 	jmp    *-0x7fef8698(,%eax,4)
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801057d0:	e8 8b df ff ff       	call   80103760 <myproc>
801057d5:	85 c0                	test   %eax,%eax
801057d7:	0f 84 d7 01 00 00    	je     801059b4 <trap+0x214>
801057dd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801057e1:	0f 84 cd 01 00 00    	je     801059b4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057e7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057ea:	8b 57 38             	mov    0x38(%edi),%edx
801057ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801057f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801057f3:	e8 48 df ff ff       	call   80103740 <cpuid>
801057f8:	8b 77 34             	mov    0x34(%edi),%esi
801057fb:	8b 5f 30             	mov    0x30(%edi),%ebx
801057fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105801:	e8 5a df ff ff       	call   80103760 <myproc>
80105806:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105809:	e8 52 df ff ff       	call   80103760 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010580e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105811:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105814:	51                   	push   %ecx
80105815:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105816:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105819:	ff 75 e4             	pushl  -0x1c(%ebp)
8010581c:	56                   	push   %esi
8010581d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010581e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105821:	52                   	push   %edx
80105822:	ff 70 10             	pushl  0x10(%eax)
80105825:	68 24 79 10 80       	push   $0x80107924
8010582a:	e8 31 ae ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010582f:	83 c4 20             	add    $0x20,%esp
80105832:	e8 29 df ff ff       	call   80103760 <myproc>
80105837:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010583e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105840:	e8 1b df ff ff       	call   80103760 <myproc>
80105845:	85 c0                	test   %eax,%eax
80105847:	74 0c                	je     80105855 <trap+0xb5>
80105849:	e8 12 df ff ff       	call   80103760 <myproc>
8010584e:	8b 50 24             	mov    0x24(%eax),%edx
80105851:	85 d2                	test   %edx,%edx
80105853:	75 4b                	jne    801058a0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105855:	e8 06 df ff ff       	call   80103760 <myproc>
8010585a:	85 c0                	test   %eax,%eax
8010585c:	74 0b                	je     80105869 <trap+0xc9>
8010585e:	e8 fd de ff ff       	call   80103760 <myproc>
80105863:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105867:	74 4f                	je     801058b8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105869:	e8 f2 de ff ff       	call   80103760 <myproc>
8010586e:	85 c0                	test   %eax,%eax
80105870:	74 1d                	je     8010588f <trap+0xef>
80105872:	e8 e9 de ff ff       	call   80103760 <myproc>
80105877:	8b 40 24             	mov    0x24(%eax),%eax
8010587a:	85 c0                	test   %eax,%eax
8010587c:	74 11                	je     8010588f <trap+0xef>
8010587e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105882:	83 e0 03             	and    $0x3,%eax
80105885:	66 83 f8 03          	cmp    $0x3,%ax
80105889:	0f 84 da 00 00 00    	je     80105969 <trap+0x1c9>
    exit();
}
8010588f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5f                   	pop    %edi
80105895:	5d                   	pop    %ebp
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058a0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058a4:	83 e0 03             	and    $0x3,%eax
801058a7:	66 83 f8 03          	cmp    $0x3,%ax
801058ab:	75 a8                	jne    80105855 <trap+0xb5>
    exit();
801058ad:	e8 de e2 ff ff       	call   80103b90 <exit>
801058b2:	eb a1                	jmp    80105855 <trap+0xb5>
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058b8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801058bc:	75 ab                	jne    80105869 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801058be:	e8 fd e3 ff ff       	call   80103cc0 <yield>
801058c3:	eb a4                	jmp    80105869 <trap+0xc9>
801058c5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801058c8:	e8 73 de ff ff       	call   80103740 <cpuid>
801058cd:	85 c0                	test   %eax,%eax
801058cf:	0f 84 ab 00 00 00    	je     80105980 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801058d5:	e8 26 ce ff ff       	call   80102700 <lapiceoi>
    break;
801058da:	e9 61 ff ff ff       	jmp    80105840 <trap+0xa0>
801058df:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801058e0:	e8 db cc ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
801058e5:	e8 16 ce ff ff       	call   80102700 <lapiceoi>
    break;
801058ea:	e9 51 ff ff ff       	jmp    80105840 <trap+0xa0>
801058ef:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801058f0:	e8 5b 02 00 00       	call   80105b50 <uartintr>
    lapiceoi();
801058f5:	e8 06 ce ff ff       	call   80102700 <lapiceoi>
    break;
801058fa:	e9 41 ff ff ff       	jmp    80105840 <trap+0xa0>
801058ff:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105900:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105904:	8b 77 38             	mov    0x38(%edi),%esi
80105907:	e8 34 de ff ff       	call   80103740 <cpuid>
8010590c:	56                   	push   %esi
8010590d:	53                   	push   %ebx
8010590e:	50                   	push   %eax
8010590f:	68 cc 78 10 80       	push   $0x801078cc
80105914:	e8 47 ad ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105919:	e8 e2 cd ff ff       	call   80102700 <lapiceoi>
    break;
8010591e:	83 c4 10             	add    $0x10,%esp
80105921:	e9 1a ff ff ff       	jmp    80105840 <trap+0xa0>
80105926:	8d 76 00             	lea    0x0(%esi),%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105930:	e8 0b c7 ff ff       	call   80102040 <ideintr>
80105935:	eb 9e                	jmp    801058d5 <trap+0x135>
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105940:	e8 1b de ff ff       	call   80103760 <myproc>
80105945:	8b 58 24             	mov    0x24(%eax),%ebx
80105948:	85 db                	test   %ebx,%ebx
8010594a:	75 2c                	jne    80105978 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010594c:	e8 0f de ff ff       	call   80103760 <myproc>
80105951:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105954:	e8 97 ee ff ff       	call   801047f0 <syscall>
    if(myproc()->killed)
80105959:	e8 02 de ff ff       	call   80103760 <myproc>
8010595e:	8b 48 24             	mov    0x24(%eax),%ecx
80105961:	85 c9                	test   %ecx,%ecx
80105963:	0f 84 26 ff ff ff    	je     8010588f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596c:	5b                   	pop    %ebx
8010596d:	5e                   	pop    %esi
8010596e:	5f                   	pop    %edi
8010596f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105970:	e9 1b e2 ff ff       	jmp    80103b90 <exit>
80105975:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105978:	e8 13 e2 ff ff       	call   80103b90 <exit>
8010597d:	eb cd                	jmp    8010594c <trap+0x1ac>
8010597f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	68 60 4c 11 80       	push   $0x80114c60
80105988:	e8 73 e9 ff ff       	call   80104300 <acquire>
      ticks++;
      wakeup(&ticks);
8010598d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105994:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010599b:	e8 20 e5 ff ff       	call   80103ec0 <wakeup>
      release(&tickslock);
801059a0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801059a7:	e8 04 ea ff ff       	call   801043b0 <release>
801059ac:	83 c4 10             	add    $0x10,%esp
801059af:	e9 21 ff ff ff       	jmp    801058d5 <trap+0x135>
801059b4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059b7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059ba:	e8 81 dd ff ff       	call   80103740 <cpuid>
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	56                   	push   %esi
801059c3:	53                   	push   %ebx
801059c4:	50                   	push   %eax
801059c5:	ff 77 30             	pushl  0x30(%edi)
801059c8:	68 f0 78 10 80       	push   $0x801078f0
801059cd:	e8 8e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801059d2:	83 c4 14             	add    $0x14,%esp
801059d5:	68 c6 78 10 80       	push   $0x801078c6
801059da:	e8 91 a9 ff ff       	call   80100370 <panic>
801059df:	90                   	nop

801059e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059e0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059e5:	55                   	push   %ebp
801059e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059e8:	85 c0                	test   %eax,%eax
801059ea:	74 1c                	je     80105a08 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059f2:	a8 01                	test   $0x1,%al
801059f4:	74 12                	je     80105a08 <uartgetc+0x28>
801059f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801059fc:	0f b6 c0             	movzbl %al,%eax
}
801059ff:	5d                   	pop    %ebp
80105a00:	c3                   	ret    
80105a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a0d:	5d                   	pop    %ebp
80105a0e:	c3                   	ret    
80105a0f:	90                   	nop

80105a10 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
80105a16:	89 c7                	mov    %eax,%edi
80105a18:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a22:	83 ec 0c             	sub    $0xc,%esp
80105a25:	eb 1b                	jmp    80105a42 <uartputc.part.0+0x32>
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	6a 0a                	push   $0xa
80105a35:	e8 e6 cc ff ff       	call   80102720 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	83 eb 01             	sub    $0x1,%ebx
80105a40:	74 07                	je     80105a49 <uartputc.part.0+0x39>
80105a42:	89 f2                	mov    %esi,%edx
80105a44:	ec                   	in     (%dx),%al
80105a45:	a8 20                	test   $0x20,%al
80105a47:	74 e7                	je     80105a30 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a4e:	89 f8                	mov    %edi,%eax
80105a50:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a54:	5b                   	pop    %ebx
80105a55:	5e                   	pop    %esi
80105a56:	5f                   	pop    %edi
80105a57:	5d                   	pop    %ebp
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a60 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a60:	55                   	push   %ebp
80105a61:	31 c9                	xor    %ecx,%ecx
80105a63:	89 c8                	mov    %ecx,%eax
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	57                   	push   %edi
80105a68:	56                   	push   %esi
80105a69:	53                   	push   %ebx
80105a6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a6f:	89 da                	mov    %ebx,%edx
80105a71:	83 ec 0c             	sub    $0xc,%esp
80105a74:	ee                   	out    %al,(%dx)
80105a75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a7f:	89 fa                	mov    %edi,%edx
80105a81:	ee                   	out    %al,(%dx)
80105a82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a8c:	ee                   	out    %al,(%dx)
80105a8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105a92:	89 c8                	mov    %ecx,%eax
80105a94:	89 f2                	mov    %esi,%edx
80105a96:	ee                   	out    %al,(%dx)
80105a97:	b8 03 00 00 00       	mov    $0x3,%eax
80105a9c:	89 fa                	mov    %edi,%edx
80105a9e:	ee                   	out    %al,(%dx)
80105a9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105aa4:	89 c8                	mov    %ecx,%eax
80105aa6:	ee                   	out    %al,(%dx)
80105aa7:	b8 01 00 00 00       	mov    $0x1,%eax
80105aac:	89 f2                	mov    %esi,%edx
80105aae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aaf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ab4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105ab5:	3c ff                	cmp    $0xff,%al
80105ab7:	74 5a                	je     80105b13 <uartinit+0xb3>
    return;
  uart = 1;
80105ab9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ac0:	00 00 00 
80105ac3:	89 da                	mov    %ebx,%edx
80105ac5:	ec                   	in     (%dx),%al
80105ac6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105acb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105acc:	83 ec 08             	sub    $0x8,%esp
80105acf:	bb e8 79 10 80       	mov    $0x801079e8,%ebx
80105ad4:	6a 00                	push   $0x0
80105ad6:	6a 04                	push   $0x4
80105ad8:	e8 b3 c7 ff ff       	call   80102290 <ioapicenable>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	b8 78 00 00 00       	mov    $0x78,%eax
80105ae5:	eb 13                	jmp    80105afa <uartinit+0x9a>
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	0f be 03             	movsbl (%ebx),%eax
80105af6:	84 c0                	test   %al,%al
80105af8:	74 19                	je     80105b13 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105afa:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b00:	85 d2                	test   %edx,%edx
80105b02:	74 ec                	je     80105af0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b04:	83 c3 01             	add    $0x1,%ebx
80105b07:	e8 04 ff ff ff       	call   80105a10 <uartputc.part.0>
80105b0c:	0f be 03             	movsbl (%ebx),%eax
80105b0f:	84 c0                	test   %al,%al
80105b11:	75 e7                	jne    80105afa <uartinit+0x9a>
    uartputc(*p);
}
80105b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b16:	5b                   	pop    %ebx
80105b17:	5e                   	pop    %esi
80105b18:	5f                   	pop    %edi
80105b19:	5d                   	pop    %ebp
80105b1a:	c3                   	ret    
80105b1b:	90                   	nop
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b20:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b26:	55                   	push   %ebp
80105b27:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b29:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b2e:	74 10                	je     80105b40 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b30:	5d                   	pop    %ebp
80105b31:	e9 da fe ff ff       	jmp    80105a10 <uartputc.part.0>
80105b36:	8d 76 00             	lea    0x0(%esi),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b40:	5d                   	pop    %ebp
80105b41:	c3                   	ret    
80105b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b56:	68 e0 59 10 80       	push   $0x801059e0
80105b5b:	e8 90 ac ff ff       	call   801007f0 <consoleintr>
}
80105b60:	83 c4 10             	add    $0x10,%esp
80105b63:	c9                   	leave  
80105b64:	c3                   	ret    

80105b65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $0
80105b67:	6a 00                	push   $0x0
  jmp alltraps
80105b69:	e9 3c fb ff ff       	jmp    801056aa <alltraps>

80105b6e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $1
80105b70:	6a 01                	push   $0x1
  jmp alltraps
80105b72:	e9 33 fb ff ff       	jmp    801056aa <alltraps>

80105b77 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $2
80105b79:	6a 02                	push   $0x2
  jmp alltraps
80105b7b:	e9 2a fb ff ff       	jmp    801056aa <alltraps>

80105b80 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $3
80105b82:	6a 03                	push   $0x3
  jmp alltraps
80105b84:	e9 21 fb ff ff       	jmp    801056aa <alltraps>

80105b89 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $4
80105b8b:	6a 04                	push   $0x4
  jmp alltraps
80105b8d:	e9 18 fb ff ff       	jmp    801056aa <alltraps>

80105b92 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $5
80105b94:	6a 05                	push   $0x5
  jmp alltraps
80105b96:	e9 0f fb ff ff       	jmp    801056aa <alltraps>

80105b9b <vector6>:
.globl vector6
vector6:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $6
80105b9d:	6a 06                	push   $0x6
  jmp alltraps
80105b9f:	e9 06 fb ff ff       	jmp    801056aa <alltraps>

80105ba4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $7
80105ba6:	6a 07                	push   $0x7
  jmp alltraps
80105ba8:	e9 fd fa ff ff       	jmp    801056aa <alltraps>

80105bad <vector8>:
.globl vector8
vector8:
  pushl $8
80105bad:	6a 08                	push   $0x8
  jmp alltraps
80105baf:	e9 f6 fa ff ff       	jmp    801056aa <alltraps>

80105bb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $9
80105bb6:	6a 09                	push   $0x9
  jmp alltraps
80105bb8:	e9 ed fa ff ff       	jmp    801056aa <alltraps>

80105bbd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bbd:	6a 0a                	push   $0xa
  jmp alltraps
80105bbf:	e9 e6 fa ff ff       	jmp    801056aa <alltraps>

80105bc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bc4:	6a 0b                	push   $0xb
  jmp alltraps
80105bc6:	e9 df fa ff ff       	jmp    801056aa <alltraps>

80105bcb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bcb:	6a 0c                	push   $0xc
  jmp alltraps
80105bcd:	e9 d8 fa ff ff       	jmp    801056aa <alltraps>

80105bd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105bd2:	6a 0d                	push   $0xd
  jmp alltraps
80105bd4:	e9 d1 fa ff ff       	jmp    801056aa <alltraps>

80105bd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105bd9:	6a 0e                	push   $0xe
  jmp alltraps
80105bdb:	e9 ca fa ff ff       	jmp    801056aa <alltraps>

80105be0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $15
80105be2:	6a 0f                	push   $0xf
  jmp alltraps
80105be4:	e9 c1 fa ff ff       	jmp    801056aa <alltraps>

80105be9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $16
80105beb:	6a 10                	push   $0x10
  jmp alltraps
80105bed:	e9 b8 fa ff ff       	jmp    801056aa <alltraps>

80105bf2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105bf2:	6a 11                	push   $0x11
  jmp alltraps
80105bf4:	e9 b1 fa ff ff       	jmp    801056aa <alltraps>

80105bf9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $18
80105bfb:	6a 12                	push   $0x12
  jmp alltraps
80105bfd:	e9 a8 fa ff ff       	jmp    801056aa <alltraps>

80105c02 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $19
80105c04:	6a 13                	push   $0x13
  jmp alltraps
80105c06:	e9 9f fa ff ff       	jmp    801056aa <alltraps>

80105c0b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $20
80105c0d:	6a 14                	push   $0x14
  jmp alltraps
80105c0f:	e9 96 fa ff ff       	jmp    801056aa <alltraps>

80105c14 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c14:	6a 00                	push   $0x0
  pushl $21
80105c16:	6a 15                	push   $0x15
  jmp alltraps
80105c18:	e9 8d fa ff ff       	jmp    801056aa <alltraps>

80105c1d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c1d:	6a 00                	push   $0x0
  pushl $22
80105c1f:	6a 16                	push   $0x16
  jmp alltraps
80105c21:	e9 84 fa ff ff       	jmp    801056aa <alltraps>

80105c26 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c26:	6a 00                	push   $0x0
  pushl $23
80105c28:	6a 17                	push   $0x17
  jmp alltraps
80105c2a:	e9 7b fa ff ff       	jmp    801056aa <alltraps>

80105c2f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $24
80105c31:	6a 18                	push   $0x18
  jmp alltraps
80105c33:	e9 72 fa ff ff       	jmp    801056aa <alltraps>

80105c38 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c38:	6a 00                	push   $0x0
  pushl $25
80105c3a:	6a 19                	push   $0x19
  jmp alltraps
80105c3c:	e9 69 fa ff ff       	jmp    801056aa <alltraps>

80105c41 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c41:	6a 00                	push   $0x0
  pushl $26
80105c43:	6a 1a                	push   $0x1a
  jmp alltraps
80105c45:	e9 60 fa ff ff       	jmp    801056aa <alltraps>

80105c4a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c4a:	6a 00                	push   $0x0
  pushl $27
80105c4c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c4e:	e9 57 fa ff ff       	jmp    801056aa <alltraps>

80105c53 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $28
80105c55:	6a 1c                	push   $0x1c
  jmp alltraps
80105c57:	e9 4e fa ff ff       	jmp    801056aa <alltraps>

80105c5c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c5c:	6a 00                	push   $0x0
  pushl $29
80105c5e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c60:	e9 45 fa ff ff       	jmp    801056aa <alltraps>

80105c65 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $30
80105c67:	6a 1e                	push   $0x1e
  jmp alltraps
80105c69:	e9 3c fa ff ff       	jmp    801056aa <alltraps>

80105c6e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $31
80105c70:	6a 1f                	push   $0x1f
  jmp alltraps
80105c72:	e9 33 fa ff ff       	jmp    801056aa <alltraps>

80105c77 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $32
80105c79:	6a 20                	push   $0x20
  jmp alltraps
80105c7b:	e9 2a fa ff ff       	jmp    801056aa <alltraps>

80105c80 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $33
80105c82:	6a 21                	push   $0x21
  jmp alltraps
80105c84:	e9 21 fa ff ff       	jmp    801056aa <alltraps>

80105c89 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $34
80105c8b:	6a 22                	push   $0x22
  jmp alltraps
80105c8d:	e9 18 fa ff ff       	jmp    801056aa <alltraps>

80105c92 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $35
80105c94:	6a 23                	push   $0x23
  jmp alltraps
80105c96:	e9 0f fa ff ff       	jmp    801056aa <alltraps>

80105c9b <vector36>:
.globl vector36
vector36:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $36
80105c9d:	6a 24                	push   $0x24
  jmp alltraps
80105c9f:	e9 06 fa ff ff       	jmp    801056aa <alltraps>

80105ca4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $37
80105ca6:	6a 25                	push   $0x25
  jmp alltraps
80105ca8:	e9 fd f9 ff ff       	jmp    801056aa <alltraps>

80105cad <vector38>:
.globl vector38
vector38:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $38
80105caf:	6a 26                	push   $0x26
  jmp alltraps
80105cb1:	e9 f4 f9 ff ff       	jmp    801056aa <alltraps>

80105cb6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $39
80105cb8:	6a 27                	push   $0x27
  jmp alltraps
80105cba:	e9 eb f9 ff ff       	jmp    801056aa <alltraps>

80105cbf <vector40>:
.globl vector40
vector40:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $40
80105cc1:	6a 28                	push   $0x28
  jmp alltraps
80105cc3:	e9 e2 f9 ff ff       	jmp    801056aa <alltraps>

80105cc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cc8:	6a 00                	push   $0x0
  pushl $41
80105cca:	6a 29                	push   $0x29
  jmp alltraps
80105ccc:	e9 d9 f9 ff ff       	jmp    801056aa <alltraps>

80105cd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $42
80105cd3:	6a 2a                	push   $0x2a
  jmp alltraps
80105cd5:	e9 d0 f9 ff ff       	jmp    801056aa <alltraps>

80105cda <vector43>:
.globl vector43
vector43:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $43
80105cdc:	6a 2b                	push   $0x2b
  jmp alltraps
80105cde:	e9 c7 f9 ff ff       	jmp    801056aa <alltraps>

80105ce3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $44
80105ce5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ce7:	e9 be f9 ff ff       	jmp    801056aa <alltraps>

80105cec <vector45>:
.globl vector45
vector45:
  pushl $0
80105cec:	6a 00                	push   $0x0
  pushl $45
80105cee:	6a 2d                	push   $0x2d
  jmp alltraps
80105cf0:	e9 b5 f9 ff ff       	jmp    801056aa <alltraps>

80105cf5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $46
80105cf7:	6a 2e                	push   $0x2e
  jmp alltraps
80105cf9:	e9 ac f9 ff ff       	jmp    801056aa <alltraps>

80105cfe <vector47>:
.globl vector47
vector47:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $47
80105d00:	6a 2f                	push   $0x2f
  jmp alltraps
80105d02:	e9 a3 f9 ff ff       	jmp    801056aa <alltraps>

80105d07 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $48
80105d09:	6a 30                	push   $0x30
  jmp alltraps
80105d0b:	e9 9a f9 ff ff       	jmp    801056aa <alltraps>

80105d10 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $49
80105d12:	6a 31                	push   $0x31
  jmp alltraps
80105d14:	e9 91 f9 ff ff       	jmp    801056aa <alltraps>

80105d19 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $50
80105d1b:	6a 32                	push   $0x32
  jmp alltraps
80105d1d:	e9 88 f9 ff ff       	jmp    801056aa <alltraps>

80105d22 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $51
80105d24:	6a 33                	push   $0x33
  jmp alltraps
80105d26:	e9 7f f9 ff ff       	jmp    801056aa <alltraps>

80105d2b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $52
80105d2d:	6a 34                	push   $0x34
  jmp alltraps
80105d2f:	e9 76 f9 ff ff       	jmp    801056aa <alltraps>

80105d34 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $53
80105d36:	6a 35                	push   $0x35
  jmp alltraps
80105d38:	e9 6d f9 ff ff       	jmp    801056aa <alltraps>

80105d3d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d3d:	6a 00                	push   $0x0
  pushl $54
80105d3f:	6a 36                	push   $0x36
  jmp alltraps
80105d41:	e9 64 f9 ff ff       	jmp    801056aa <alltraps>

80105d46 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $55
80105d48:	6a 37                	push   $0x37
  jmp alltraps
80105d4a:	e9 5b f9 ff ff       	jmp    801056aa <alltraps>

80105d4f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $56
80105d51:	6a 38                	push   $0x38
  jmp alltraps
80105d53:	e9 52 f9 ff ff       	jmp    801056aa <alltraps>

80105d58 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $57
80105d5a:	6a 39                	push   $0x39
  jmp alltraps
80105d5c:	e9 49 f9 ff ff       	jmp    801056aa <alltraps>

80105d61 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $58
80105d63:	6a 3a                	push   $0x3a
  jmp alltraps
80105d65:	e9 40 f9 ff ff       	jmp    801056aa <alltraps>

80105d6a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $59
80105d6c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d6e:	e9 37 f9 ff ff       	jmp    801056aa <alltraps>

80105d73 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $60
80105d75:	6a 3c                	push   $0x3c
  jmp alltraps
80105d77:	e9 2e f9 ff ff       	jmp    801056aa <alltraps>

80105d7c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $61
80105d7e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d80:	e9 25 f9 ff ff       	jmp    801056aa <alltraps>

80105d85 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $62
80105d87:	6a 3e                	push   $0x3e
  jmp alltraps
80105d89:	e9 1c f9 ff ff       	jmp    801056aa <alltraps>

80105d8e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $63
80105d90:	6a 3f                	push   $0x3f
  jmp alltraps
80105d92:	e9 13 f9 ff ff       	jmp    801056aa <alltraps>

80105d97 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $64
80105d99:	6a 40                	push   $0x40
  jmp alltraps
80105d9b:	e9 0a f9 ff ff       	jmp    801056aa <alltraps>

80105da0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $65
80105da2:	6a 41                	push   $0x41
  jmp alltraps
80105da4:	e9 01 f9 ff ff       	jmp    801056aa <alltraps>

80105da9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $66
80105dab:	6a 42                	push   $0x42
  jmp alltraps
80105dad:	e9 f8 f8 ff ff       	jmp    801056aa <alltraps>

80105db2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $67
80105db4:	6a 43                	push   $0x43
  jmp alltraps
80105db6:	e9 ef f8 ff ff       	jmp    801056aa <alltraps>

80105dbb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $68
80105dbd:	6a 44                	push   $0x44
  jmp alltraps
80105dbf:	e9 e6 f8 ff ff       	jmp    801056aa <alltraps>

80105dc4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $69
80105dc6:	6a 45                	push   $0x45
  jmp alltraps
80105dc8:	e9 dd f8 ff ff       	jmp    801056aa <alltraps>

80105dcd <vector70>:
.globl vector70
vector70:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $70
80105dcf:	6a 46                	push   $0x46
  jmp alltraps
80105dd1:	e9 d4 f8 ff ff       	jmp    801056aa <alltraps>

80105dd6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $71
80105dd8:	6a 47                	push   $0x47
  jmp alltraps
80105dda:	e9 cb f8 ff ff       	jmp    801056aa <alltraps>

80105ddf <vector72>:
.globl vector72
vector72:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $72
80105de1:	6a 48                	push   $0x48
  jmp alltraps
80105de3:	e9 c2 f8 ff ff       	jmp    801056aa <alltraps>

80105de8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $73
80105dea:	6a 49                	push   $0x49
  jmp alltraps
80105dec:	e9 b9 f8 ff ff       	jmp    801056aa <alltraps>

80105df1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $74
80105df3:	6a 4a                	push   $0x4a
  jmp alltraps
80105df5:	e9 b0 f8 ff ff       	jmp    801056aa <alltraps>

80105dfa <vector75>:
.globl vector75
vector75:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $75
80105dfc:	6a 4b                	push   $0x4b
  jmp alltraps
80105dfe:	e9 a7 f8 ff ff       	jmp    801056aa <alltraps>

80105e03 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $76
80105e05:	6a 4c                	push   $0x4c
  jmp alltraps
80105e07:	e9 9e f8 ff ff       	jmp    801056aa <alltraps>

80105e0c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $77
80105e0e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e10:	e9 95 f8 ff ff       	jmp    801056aa <alltraps>

80105e15 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $78
80105e17:	6a 4e                	push   $0x4e
  jmp alltraps
80105e19:	e9 8c f8 ff ff       	jmp    801056aa <alltraps>

80105e1e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $79
80105e20:	6a 4f                	push   $0x4f
  jmp alltraps
80105e22:	e9 83 f8 ff ff       	jmp    801056aa <alltraps>

80105e27 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $80
80105e29:	6a 50                	push   $0x50
  jmp alltraps
80105e2b:	e9 7a f8 ff ff       	jmp    801056aa <alltraps>

80105e30 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $81
80105e32:	6a 51                	push   $0x51
  jmp alltraps
80105e34:	e9 71 f8 ff ff       	jmp    801056aa <alltraps>

80105e39 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $82
80105e3b:	6a 52                	push   $0x52
  jmp alltraps
80105e3d:	e9 68 f8 ff ff       	jmp    801056aa <alltraps>

80105e42 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $83
80105e44:	6a 53                	push   $0x53
  jmp alltraps
80105e46:	e9 5f f8 ff ff       	jmp    801056aa <alltraps>

80105e4b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $84
80105e4d:	6a 54                	push   $0x54
  jmp alltraps
80105e4f:	e9 56 f8 ff ff       	jmp    801056aa <alltraps>

80105e54 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $85
80105e56:	6a 55                	push   $0x55
  jmp alltraps
80105e58:	e9 4d f8 ff ff       	jmp    801056aa <alltraps>

80105e5d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $86
80105e5f:	6a 56                	push   $0x56
  jmp alltraps
80105e61:	e9 44 f8 ff ff       	jmp    801056aa <alltraps>

80105e66 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $87
80105e68:	6a 57                	push   $0x57
  jmp alltraps
80105e6a:	e9 3b f8 ff ff       	jmp    801056aa <alltraps>

80105e6f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $88
80105e71:	6a 58                	push   $0x58
  jmp alltraps
80105e73:	e9 32 f8 ff ff       	jmp    801056aa <alltraps>

80105e78 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $89
80105e7a:	6a 59                	push   $0x59
  jmp alltraps
80105e7c:	e9 29 f8 ff ff       	jmp    801056aa <alltraps>

80105e81 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $90
80105e83:	6a 5a                	push   $0x5a
  jmp alltraps
80105e85:	e9 20 f8 ff ff       	jmp    801056aa <alltraps>

80105e8a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $91
80105e8c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e8e:	e9 17 f8 ff ff       	jmp    801056aa <alltraps>

80105e93 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $92
80105e95:	6a 5c                	push   $0x5c
  jmp alltraps
80105e97:	e9 0e f8 ff ff       	jmp    801056aa <alltraps>

80105e9c <vector93>:
.globl vector93
vector93:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $93
80105e9e:	6a 5d                	push   $0x5d
  jmp alltraps
80105ea0:	e9 05 f8 ff ff       	jmp    801056aa <alltraps>

80105ea5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $94
80105ea7:	6a 5e                	push   $0x5e
  jmp alltraps
80105ea9:	e9 fc f7 ff ff       	jmp    801056aa <alltraps>

80105eae <vector95>:
.globl vector95
vector95:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $95
80105eb0:	6a 5f                	push   $0x5f
  jmp alltraps
80105eb2:	e9 f3 f7 ff ff       	jmp    801056aa <alltraps>

80105eb7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $96
80105eb9:	6a 60                	push   $0x60
  jmp alltraps
80105ebb:	e9 ea f7 ff ff       	jmp    801056aa <alltraps>

80105ec0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $97
80105ec2:	6a 61                	push   $0x61
  jmp alltraps
80105ec4:	e9 e1 f7 ff ff       	jmp    801056aa <alltraps>

80105ec9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $98
80105ecb:	6a 62                	push   $0x62
  jmp alltraps
80105ecd:	e9 d8 f7 ff ff       	jmp    801056aa <alltraps>

80105ed2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $99
80105ed4:	6a 63                	push   $0x63
  jmp alltraps
80105ed6:	e9 cf f7 ff ff       	jmp    801056aa <alltraps>

80105edb <vector100>:
.globl vector100
vector100:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $100
80105edd:	6a 64                	push   $0x64
  jmp alltraps
80105edf:	e9 c6 f7 ff ff       	jmp    801056aa <alltraps>

80105ee4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $101
80105ee6:	6a 65                	push   $0x65
  jmp alltraps
80105ee8:	e9 bd f7 ff ff       	jmp    801056aa <alltraps>

80105eed <vector102>:
.globl vector102
vector102:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $102
80105eef:	6a 66                	push   $0x66
  jmp alltraps
80105ef1:	e9 b4 f7 ff ff       	jmp    801056aa <alltraps>

80105ef6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $103
80105ef8:	6a 67                	push   $0x67
  jmp alltraps
80105efa:	e9 ab f7 ff ff       	jmp    801056aa <alltraps>

80105eff <vector104>:
.globl vector104
vector104:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $104
80105f01:	6a 68                	push   $0x68
  jmp alltraps
80105f03:	e9 a2 f7 ff ff       	jmp    801056aa <alltraps>

80105f08 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $105
80105f0a:	6a 69                	push   $0x69
  jmp alltraps
80105f0c:	e9 99 f7 ff ff       	jmp    801056aa <alltraps>

80105f11 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $106
80105f13:	6a 6a                	push   $0x6a
  jmp alltraps
80105f15:	e9 90 f7 ff ff       	jmp    801056aa <alltraps>

80105f1a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $107
80105f1c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f1e:	e9 87 f7 ff ff       	jmp    801056aa <alltraps>

80105f23 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $108
80105f25:	6a 6c                	push   $0x6c
  jmp alltraps
80105f27:	e9 7e f7 ff ff       	jmp    801056aa <alltraps>

80105f2c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $109
80105f2e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f30:	e9 75 f7 ff ff       	jmp    801056aa <alltraps>

80105f35 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $110
80105f37:	6a 6e                	push   $0x6e
  jmp alltraps
80105f39:	e9 6c f7 ff ff       	jmp    801056aa <alltraps>

80105f3e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $111
80105f40:	6a 6f                	push   $0x6f
  jmp alltraps
80105f42:	e9 63 f7 ff ff       	jmp    801056aa <alltraps>

80105f47 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $112
80105f49:	6a 70                	push   $0x70
  jmp alltraps
80105f4b:	e9 5a f7 ff ff       	jmp    801056aa <alltraps>

80105f50 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $113
80105f52:	6a 71                	push   $0x71
  jmp alltraps
80105f54:	e9 51 f7 ff ff       	jmp    801056aa <alltraps>

80105f59 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $114
80105f5b:	6a 72                	push   $0x72
  jmp alltraps
80105f5d:	e9 48 f7 ff ff       	jmp    801056aa <alltraps>

80105f62 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $115
80105f64:	6a 73                	push   $0x73
  jmp alltraps
80105f66:	e9 3f f7 ff ff       	jmp    801056aa <alltraps>

80105f6b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $116
80105f6d:	6a 74                	push   $0x74
  jmp alltraps
80105f6f:	e9 36 f7 ff ff       	jmp    801056aa <alltraps>

80105f74 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $117
80105f76:	6a 75                	push   $0x75
  jmp alltraps
80105f78:	e9 2d f7 ff ff       	jmp    801056aa <alltraps>

80105f7d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $118
80105f7f:	6a 76                	push   $0x76
  jmp alltraps
80105f81:	e9 24 f7 ff ff       	jmp    801056aa <alltraps>

80105f86 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $119
80105f88:	6a 77                	push   $0x77
  jmp alltraps
80105f8a:	e9 1b f7 ff ff       	jmp    801056aa <alltraps>

80105f8f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $120
80105f91:	6a 78                	push   $0x78
  jmp alltraps
80105f93:	e9 12 f7 ff ff       	jmp    801056aa <alltraps>

80105f98 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $121
80105f9a:	6a 79                	push   $0x79
  jmp alltraps
80105f9c:	e9 09 f7 ff ff       	jmp    801056aa <alltraps>

80105fa1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $122
80105fa3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fa5:	e9 00 f7 ff ff       	jmp    801056aa <alltraps>

80105faa <vector123>:
.globl vector123
vector123:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $123
80105fac:	6a 7b                	push   $0x7b
  jmp alltraps
80105fae:	e9 f7 f6 ff ff       	jmp    801056aa <alltraps>

80105fb3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $124
80105fb5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fb7:	e9 ee f6 ff ff       	jmp    801056aa <alltraps>

80105fbc <vector125>:
.globl vector125
vector125:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $125
80105fbe:	6a 7d                	push   $0x7d
  jmp alltraps
80105fc0:	e9 e5 f6 ff ff       	jmp    801056aa <alltraps>

80105fc5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $126
80105fc7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fc9:	e9 dc f6 ff ff       	jmp    801056aa <alltraps>

80105fce <vector127>:
.globl vector127
vector127:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $127
80105fd0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fd2:	e9 d3 f6 ff ff       	jmp    801056aa <alltraps>

80105fd7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $128
80105fd9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fde:	e9 c7 f6 ff ff       	jmp    801056aa <alltraps>

80105fe3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $129
80105fe5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105fea:	e9 bb f6 ff ff       	jmp    801056aa <alltraps>

80105fef <vector130>:
.globl vector130
vector130:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $130
80105ff1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ff6:	e9 af f6 ff ff       	jmp    801056aa <alltraps>

80105ffb <vector131>:
.globl vector131
vector131:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $131
80105ffd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106002:	e9 a3 f6 ff ff       	jmp    801056aa <alltraps>

80106007 <vector132>:
.globl vector132
vector132:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $132
80106009:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010600e:	e9 97 f6 ff ff       	jmp    801056aa <alltraps>

80106013 <vector133>:
.globl vector133
vector133:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $133
80106015:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010601a:	e9 8b f6 ff ff       	jmp    801056aa <alltraps>

8010601f <vector134>:
.globl vector134
vector134:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $134
80106021:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106026:	e9 7f f6 ff ff       	jmp    801056aa <alltraps>

8010602b <vector135>:
.globl vector135
vector135:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $135
8010602d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106032:	e9 73 f6 ff ff       	jmp    801056aa <alltraps>

80106037 <vector136>:
.globl vector136
vector136:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $136
80106039:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010603e:	e9 67 f6 ff ff       	jmp    801056aa <alltraps>

80106043 <vector137>:
.globl vector137
vector137:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $137
80106045:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010604a:	e9 5b f6 ff ff       	jmp    801056aa <alltraps>

8010604f <vector138>:
.globl vector138
vector138:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $138
80106051:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106056:	e9 4f f6 ff ff       	jmp    801056aa <alltraps>

8010605b <vector139>:
.globl vector139
vector139:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $139
8010605d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106062:	e9 43 f6 ff ff       	jmp    801056aa <alltraps>

80106067 <vector140>:
.globl vector140
vector140:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $140
80106069:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010606e:	e9 37 f6 ff ff       	jmp    801056aa <alltraps>

80106073 <vector141>:
.globl vector141
vector141:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $141
80106075:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010607a:	e9 2b f6 ff ff       	jmp    801056aa <alltraps>

8010607f <vector142>:
.globl vector142
vector142:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $142
80106081:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106086:	e9 1f f6 ff ff       	jmp    801056aa <alltraps>

8010608b <vector143>:
.globl vector143
vector143:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $143
8010608d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106092:	e9 13 f6 ff ff       	jmp    801056aa <alltraps>

80106097 <vector144>:
.globl vector144
vector144:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $144
80106099:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010609e:	e9 07 f6 ff ff       	jmp    801056aa <alltraps>

801060a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $145
801060a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060aa:	e9 fb f5 ff ff       	jmp    801056aa <alltraps>

801060af <vector146>:
.globl vector146
vector146:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $146
801060b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060b6:	e9 ef f5 ff ff       	jmp    801056aa <alltraps>

801060bb <vector147>:
.globl vector147
vector147:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $147
801060bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060c2:	e9 e3 f5 ff ff       	jmp    801056aa <alltraps>

801060c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $148
801060c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060ce:	e9 d7 f5 ff ff       	jmp    801056aa <alltraps>

801060d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $149
801060d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060da:	e9 cb f5 ff ff       	jmp    801056aa <alltraps>

801060df <vector150>:
.globl vector150
vector150:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $150
801060e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060e6:	e9 bf f5 ff ff       	jmp    801056aa <alltraps>

801060eb <vector151>:
.globl vector151
vector151:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $151
801060ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801060f2:	e9 b3 f5 ff ff       	jmp    801056aa <alltraps>

801060f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $152
801060f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801060fe:	e9 a7 f5 ff ff       	jmp    801056aa <alltraps>

80106103 <vector153>:
.globl vector153
vector153:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $153
80106105:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010610a:	e9 9b f5 ff ff       	jmp    801056aa <alltraps>

8010610f <vector154>:
.globl vector154
vector154:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $154
80106111:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106116:	e9 8f f5 ff ff       	jmp    801056aa <alltraps>

8010611b <vector155>:
.globl vector155
vector155:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $155
8010611d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106122:	e9 83 f5 ff ff       	jmp    801056aa <alltraps>

80106127 <vector156>:
.globl vector156
vector156:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $156
80106129:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010612e:	e9 77 f5 ff ff       	jmp    801056aa <alltraps>

80106133 <vector157>:
.globl vector157
vector157:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $157
80106135:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010613a:	e9 6b f5 ff ff       	jmp    801056aa <alltraps>

8010613f <vector158>:
.globl vector158
vector158:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $158
80106141:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106146:	e9 5f f5 ff ff       	jmp    801056aa <alltraps>

8010614b <vector159>:
.globl vector159
vector159:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $159
8010614d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106152:	e9 53 f5 ff ff       	jmp    801056aa <alltraps>

80106157 <vector160>:
.globl vector160
vector160:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $160
80106159:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010615e:	e9 47 f5 ff ff       	jmp    801056aa <alltraps>

80106163 <vector161>:
.globl vector161
vector161:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $161
80106165:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010616a:	e9 3b f5 ff ff       	jmp    801056aa <alltraps>

8010616f <vector162>:
.globl vector162
vector162:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $162
80106171:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106176:	e9 2f f5 ff ff       	jmp    801056aa <alltraps>

8010617b <vector163>:
.globl vector163
vector163:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $163
8010617d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106182:	e9 23 f5 ff ff       	jmp    801056aa <alltraps>

80106187 <vector164>:
.globl vector164
vector164:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $164
80106189:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010618e:	e9 17 f5 ff ff       	jmp    801056aa <alltraps>

80106193 <vector165>:
.globl vector165
vector165:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $165
80106195:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010619a:	e9 0b f5 ff ff       	jmp    801056aa <alltraps>

8010619f <vector166>:
.globl vector166
vector166:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $166
801061a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061a6:	e9 ff f4 ff ff       	jmp    801056aa <alltraps>

801061ab <vector167>:
.globl vector167
vector167:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $167
801061ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061b2:	e9 f3 f4 ff ff       	jmp    801056aa <alltraps>

801061b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $168
801061b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061be:	e9 e7 f4 ff ff       	jmp    801056aa <alltraps>

801061c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $169
801061c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061ca:	e9 db f4 ff ff       	jmp    801056aa <alltraps>

801061cf <vector170>:
.globl vector170
vector170:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $170
801061d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061d6:	e9 cf f4 ff ff       	jmp    801056aa <alltraps>

801061db <vector171>:
.globl vector171
vector171:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $171
801061dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061e2:	e9 c3 f4 ff ff       	jmp    801056aa <alltraps>

801061e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $172
801061e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061ee:	e9 b7 f4 ff ff       	jmp    801056aa <alltraps>

801061f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $173
801061f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801061fa:	e9 ab f4 ff ff       	jmp    801056aa <alltraps>

801061ff <vector174>:
.globl vector174
vector174:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $174
80106201:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106206:	e9 9f f4 ff ff       	jmp    801056aa <alltraps>

8010620b <vector175>:
.globl vector175
vector175:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $175
8010620d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106212:	e9 93 f4 ff ff       	jmp    801056aa <alltraps>

80106217 <vector176>:
.globl vector176
vector176:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $176
80106219:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010621e:	e9 87 f4 ff ff       	jmp    801056aa <alltraps>

80106223 <vector177>:
.globl vector177
vector177:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $177
80106225:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010622a:	e9 7b f4 ff ff       	jmp    801056aa <alltraps>

8010622f <vector178>:
.globl vector178
vector178:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $178
80106231:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106236:	e9 6f f4 ff ff       	jmp    801056aa <alltraps>

8010623b <vector179>:
.globl vector179
vector179:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $179
8010623d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106242:	e9 63 f4 ff ff       	jmp    801056aa <alltraps>

80106247 <vector180>:
.globl vector180
vector180:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $180
80106249:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010624e:	e9 57 f4 ff ff       	jmp    801056aa <alltraps>

80106253 <vector181>:
.globl vector181
vector181:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $181
80106255:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010625a:	e9 4b f4 ff ff       	jmp    801056aa <alltraps>

8010625f <vector182>:
.globl vector182
vector182:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $182
80106261:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106266:	e9 3f f4 ff ff       	jmp    801056aa <alltraps>

8010626b <vector183>:
.globl vector183
vector183:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $183
8010626d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106272:	e9 33 f4 ff ff       	jmp    801056aa <alltraps>

80106277 <vector184>:
.globl vector184
vector184:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $184
80106279:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010627e:	e9 27 f4 ff ff       	jmp    801056aa <alltraps>

80106283 <vector185>:
.globl vector185
vector185:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $185
80106285:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010628a:	e9 1b f4 ff ff       	jmp    801056aa <alltraps>

8010628f <vector186>:
.globl vector186
vector186:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $186
80106291:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106296:	e9 0f f4 ff ff       	jmp    801056aa <alltraps>

8010629b <vector187>:
.globl vector187
vector187:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $187
8010629d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062a2:	e9 03 f4 ff ff       	jmp    801056aa <alltraps>

801062a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $188
801062a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062ae:	e9 f7 f3 ff ff       	jmp    801056aa <alltraps>

801062b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $189
801062b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ba:	e9 eb f3 ff ff       	jmp    801056aa <alltraps>

801062bf <vector190>:
.globl vector190
vector190:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $190
801062c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062c6:	e9 df f3 ff ff       	jmp    801056aa <alltraps>

801062cb <vector191>:
.globl vector191
vector191:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $191
801062cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062d2:	e9 d3 f3 ff ff       	jmp    801056aa <alltraps>

801062d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $192
801062d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062de:	e9 c7 f3 ff ff       	jmp    801056aa <alltraps>

801062e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $193
801062e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062ea:	e9 bb f3 ff ff       	jmp    801056aa <alltraps>

801062ef <vector194>:
.globl vector194
vector194:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $194
801062f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801062f6:	e9 af f3 ff ff       	jmp    801056aa <alltraps>

801062fb <vector195>:
.globl vector195
vector195:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $195
801062fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106302:	e9 a3 f3 ff ff       	jmp    801056aa <alltraps>

80106307 <vector196>:
.globl vector196
vector196:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $196
80106309:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010630e:	e9 97 f3 ff ff       	jmp    801056aa <alltraps>

80106313 <vector197>:
.globl vector197
vector197:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $197
80106315:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010631a:	e9 8b f3 ff ff       	jmp    801056aa <alltraps>

8010631f <vector198>:
.globl vector198
vector198:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $198
80106321:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106326:	e9 7f f3 ff ff       	jmp    801056aa <alltraps>

8010632b <vector199>:
.globl vector199
vector199:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $199
8010632d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106332:	e9 73 f3 ff ff       	jmp    801056aa <alltraps>

80106337 <vector200>:
.globl vector200
vector200:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $200
80106339:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010633e:	e9 67 f3 ff ff       	jmp    801056aa <alltraps>

80106343 <vector201>:
.globl vector201
vector201:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $201
80106345:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010634a:	e9 5b f3 ff ff       	jmp    801056aa <alltraps>

8010634f <vector202>:
.globl vector202
vector202:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $202
80106351:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106356:	e9 4f f3 ff ff       	jmp    801056aa <alltraps>

8010635b <vector203>:
.globl vector203
vector203:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $203
8010635d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106362:	e9 43 f3 ff ff       	jmp    801056aa <alltraps>

80106367 <vector204>:
.globl vector204
vector204:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $204
80106369:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010636e:	e9 37 f3 ff ff       	jmp    801056aa <alltraps>

80106373 <vector205>:
.globl vector205
vector205:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $205
80106375:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010637a:	e9 2b f3 ff ff       	jmp    801056aa <alltraps>

8010637f <vector206>:
.globl vector206
vector206:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $206
80106381:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106386:	e9 1f f3 ff ff       	jmp    801056aa <alltraps>

8010638b <vector207>:
.globl vector207
vector207:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $207
8010638d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106392:	e9 13 f3 ff ff       	jmp    801056aa <alltraps>

80106397 <vector208>:
.globl vector208
vector208:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $208
80106399:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010639e:	e9 07 f3 ff ff       	jmp    801056aa <alltraps>

801063a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $209
801063a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063aa:	e9 fb f2 ff ff       	jmp    801056aa <alltraps>

801063af <vector210>:
.globl vector210
vector210:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $210
801063b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063b6:	e9 ef f2 ff ff       	jmp    801056aa <alltraps>

801063bb <vector211>:
.globl vector211
vector211:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $211
801063bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063c2:	e9 e3 f2 ff ff       	jmp    801056aa <alltraps>

801063c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $212
801063c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063ce:	e9 d7 f2 ff ff       	jmp    801056aa <alltraps>

801063d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $213
801063d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063da:	e9 cb f2 ff ff       	jmp    801056aa <alltraps>

801063df <vector214>:
.globl vector214
vector214:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $214
801063e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063e6:	e9 bf f2 ff ff       	jmp    801056aa <alltraps>

801063eb <vector215>:
.globl vector215
vector215:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $215
801063ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801063f2:	e9 b3 f2 ff ff       	jmp    801056aa <alltraps>

801063f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $216
801063f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801063fe:	e9 a7 f2 ff ff       	jmp    801056aa <alltraps>

80106403 <vector217>:
.globl vector217
vector217:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $217
80106405:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010640a:	e9 9b f2 ff ff       	jmp    801056aa <alltraps>

8010640f <vector218>:
.globl vector218
vector218:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $218
80106411:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106416:	e9 8f f2 ff ff       	jmp    801056aa <alltraps>

8010641b <vector219>:
.globl vector219
vector219:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $219
8010641d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106422:	e9 83 f2 ff ff       	jmp    801056aa <alltraps>

80106427 <vector220>:
.globl vector220
vector220:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $220
80106429:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010642e:	e9 77 f2 ff ff       	jmp    801056aa <alltraps>

80106433 <vector221>:
.globl vector221
vector221:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $221
80106435:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010643a:	e9 6b f2 ff ff       	jmp    801056aa <alltraps>

8010643f <vector222>:
.globl vector222
vector222:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $222
80106441:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106446:	e9 5f f2 ff ff       	jmp    801056aa <alltraps>

8010644b <vector223>:
.globl vector223
vector223:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $223
8010644d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106452:	e9 53 f2 ff ff       	jmp    801056aa <alltraps>

80106457 <vector224>:
.globl vector224
vector224:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $224
80106459:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010645e:	e9 47 f2 ff ff       	jmp    801056aa <alltraps>

80106463 <vector225>:
.globl vector225
vector225:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $225
80106465:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010646a:	e9 3b f2 ff ff       	jmp    801056aa <alltraps>

8010646f <vector226>:
.globl vector226
vector226:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $226
80106471:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106476:	e9 2f f2 ff ff       	jmp    801056aa <alltraps>

8010647b <vector227>:
.globl vector227
vector227:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $227
8010647d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106482:	e9 23 f2 ff ff       	jmp    801056aa <alltraps>

80106487 <vector228>:
.globl vector228
vector228:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $228
80106489:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010648e:	e9 17 f2 ff ff       	jmp    801056aa <alltraps>

80106493 <vector229>:
.globl vector229
vector229:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $229
80106495:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010649a:	e9 0b f2 ff ff       	jmp    801056aa <alltraps>

8010649f <vector230>:
.globl vector230
vector230:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $230
801064a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064a6:	e9 ff f1 ff ff       	jmp    801056aa <alltraps>

801064ab <vector231>:
.globl vector231
vector231:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $231
801064ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064b2:	e9 f3 f1 ff ff       	jmp    801056aa <alltraps>

801064b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $232
801064b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064be:	e9 e7 f1 ff ff       	jmp    801056aa <alltraps>

801064c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $233
801064c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064ca:	e9 db f1 ff ff       	jmp    801056aa <alltraps>

801064cf <vector234>:
.globl vector234
vector234:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $234
801064d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064d6:	e9 cf f1 ff ff       	jmp    801056aa <alltraps>

801064db <vector235>:
.globl vector235
vector235:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $235
801064dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064e2:	e9 c3 f1 ff ff       	jmp    801056aa <alltraps>

801064e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $236
801064e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064ee:	e9 b7 f1 ff ff       	jmp    801056aa <alltraps>

801064f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $237
801064f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801064fa:	e9 ab f1 ff ff       	jmp    801056aa <alltraps>

801064ff <vector238>:
.globl vector238
vector238:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $238
80106501:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106506:	e9 9f f1 ff ff       	jmp    801056aa <alltraps>

8010650b <vector239>:
.globl vector239
vector239:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $239
8010650d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106512:	e9 93 f1 ff ff       	jmp    801056aa <alltraps>

80106517 <vector240>:
.globl vector240
vector240:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $240
80106519:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010651e:	e9 87 f1 ff ff       	jmp    801056aa <alltraps>

80106523 <vector241>:
.globl vector241
vector241:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $241
80106525:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010652a:	e9 7b f1 ff ff       	jmp    801056aa <alltraps>

8010652f <vector242>:
.globl vector242
vector242:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $242
80106531:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106536:	e9 6f f1 ff ff       	jmp    801056aa <alltraps>

8010653b <vector243>:
.globl vector243
vector243:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $243
8010653d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106542:	e9 63 f1 ff ff       	jmp    801056aa <alltraps>

80106547 <vector244>:
.globl vector244
vector244:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $244
80106549:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010654e:	e9 57 f1 ff ff       	jmp    801056aa <alltraps>

80106553 <vector245>:
.globl vector245
vector245:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $245
80106555:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010655a:	e9 4b f1 ff ff       	jmp    801056aa <alltraps>

8010655f <vector246>:
.globl vector246
vector246:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $246
80106561:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106566:	e9 3f f1 ff ff       	jmp    801056aa <alltraps>

8010656b <vector247>:
.globl vector247
vector247:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $247
8010656d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106572:	e9 33 f1 ff ff       	jmp    801056aa <alltraps>

80106577 <vector248>:
.globl vector248
vector248:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $248
80106579:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010657e:	e9 27 f1 ff ff       	jmp    801056aa <alltraps>

80106583 <vector249>:
.globl vector249
vector249:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $249
80106585:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010658a:	e9 1b f1 ff ff       	jmp    801056aa <alltraps>

8010658f <vector250>:
.globl vector250
vector250:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $250
80106591:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106596:	e9 0f f1 ff ff       	jmp    801056aa <alltraps>

8010659b <vector251>:
.globl vector251
vector251:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $251
8010659d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065a2:	e9 03 f1 ff ff       	jmp    801056aa <alltraps>

801065a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $252
801065a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065ae:	e9 f7 f0 ff ff       	jmp    801056aa <alltraps>

801065b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $253
801065b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ba:	e9 eb f0 ff ff       	jmp    801056aa <alltraps>

801065bf <vector254>:
.globl vector254
vector254:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $254
801065c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065c6:	e9 df f0 ff ff       	jmp    801056aa <alltraps>

801065cb <vector255>:
.globl vector255
vector255:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $255
801065cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065d2:	e9 d3 f0 ff ff       	jmp    801056aa <alltraps>
801065d7:	66 90                	xchg   %ax,%ax
801065d9:	66 90                	xchg   %ax,%ax
801065db:	66 90                	xchg   %ax,%ax
801065dd:	66 90                	xchg   %ax,%ax
801065df:	90                   	nop

801065e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
801065e6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065e8:	c1 ea 16             	shr    $0x16,%edx
801065eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065ee:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801065f1:	8b 07                	mov    (%edi),%eax
801065f3:	a8 01                	test   $0x1,%al
801065f5:	74 29                	je     80106620 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801065f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065fc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106602:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106605:	c1 eb 0a             	shr    $0xa,%ebx
80106608:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010660e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106611:	5b                   	pop    %ebx
80106612:	5e                   	pop    %esi
80106613:	5f                   	pop    %edi
80106614:	5d                   	pop    %ebp
80106615:	c3                   	ret    
80106616:	8d 76 00             	lea    0x0(%esi),%esi
80106619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106620:	85 c9                	test   %ecx,%ecx
80106622:	74 2c                	je     80106650 <walkpgdir+0x70>
80106624:	e8 57 be ff ff       	call   80102480 <kalloc>
80106629:	85 c0                	test   %eax,%eax
8010662b:	89 c6                	mov    %eax,%esi
8010662d:	74 21                	je     80106650 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010662f:	83 ec 04             	sub    $0x4,%esp
80106632:	68 00 10 00 00       	push   $0x1000
80106637:	6a 00                	push   $0x0
80106639:	50                   	push   %eax
8010663a:	e8 c1 dd ff ff       	call   80104400 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010663f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106645:	83 c4 10             	add    $0x10,%esp
80106648:	83 c8 07             	or     $0x7,%eax
8010664b:	89 07                	mov    %eax,(%edi)
8010664d:	eb b3                	jmp    80106602 <walkpgdir+0x22>
8010664f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106653:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106655:	5b                   	pop    %ebx
80106656:	5e                   	pop    %esi
80106657:	5f                   	pop    %edi
80106658:	5d                   	pop    %ebp
80106659:	c3                   	ret    
8010665a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106660 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	56                   	push   %esi
80106665:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106666:	89 d3                	mov    %edx,%ebx
80106668:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010666e:	83 ec 1c             	sub    $0x1c,%esp
80106671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106674:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106678:	8b 7d 08             	mov    0x8(%ebp),%edi
8010667b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106680:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106683:	8b 45 0c             	mov    0xc(%ebp),%eax
80106686:	29 df                	sub    %ebx,%edi
80106688:	83 c8 01             	or     $0x1,%eax
8010668b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010668e:	eb 15                	jmp    801066a5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106690:	f6 00 01             	testb  $0x1,(%eax)
80106693:	75 45                	jne    801066da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106695:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106698:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010669b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010669d:	74 31                	je     801066d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010669f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801066ad:	89 da                	mov    %ebx,%edx
801066af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801066b2:	e8 29 ff ff ff       	call   801065e0 <walkpgdir>
801066b7:	85 c0                	test   %eax,%eax
801066b9:	75 d5                	jne    80106690 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801066bb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801066be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801066c3:	5b                   	pop    %ebx
801066c4:	5e                   	pop    %esi
801066c5:	5f                   	pop    %edi
801066c6:	5d                   	pop    %ebp
801066c7:	c3                   	ret    
801066c8:	90                   	nop
801066c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801066d3:	31 c0                	xor    %eax,%eax
}
801066d5:	5b                   	pop    %ebx
801066d6:	5e                   	pop    %esi
801066d7:	5f                   	pop    %edi
801066d8:	5d                   	pop    %ebp
801066d9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801066da:	83 ec 0c             	sub    $0xc,%esp
801066dd:	68 f0 79 10 80       	push   $0x801079f0
801066e2:	e8 89 9c ff ff       	call   80100370 <panic>
801066e7:	89 f6                	mov    %esi,%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066fc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106704:	83 ec 1c             	sub    $0x1c,%esp
80106707:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010670a:	39 d3                	cmp    %edx,%ebx
8010670c:	73 66                	jae    80106774 <deallocuvm.part.0+0x84>
8010670e:	89 d6                	mov    %edx,%esi
80106710:	eb 3d                	jmp    8010674f <deallocuvm.part.0+0x5f>
80106712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106718:	8b 10                	mov    (%eax),%edx
8010671a:	f6 c2 01             	test   $0x1,%dl
8010671d:	74 26                	je     80106745 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010671f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106725:	74 58                	je     8010677f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106727:	83 ec 0c             	sub    $0xc,%esp
8010672a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106733:	52                   	push   %edx
80106734:	e8 97 bb ff ff       	call   801022d0 <kfree>
      *pte = 0;
80106739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010673c:	83 c4 10             	add    $0x10,%esp
8010673f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106745:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010674b:	39 f3                	cmp    %esi,%ebx
8010674d:	73 25                	jae    80106774 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010674f:	31 c9                	xor    %ecx,%ecx
80106751:	89 da                	mov    %ebx,%edx
80106753:	89 f8                	mov    %edi,%eax
80106755:	e8 86 fe ff ff       	call   801065e0 <walkpgdir>
    if(!pte)
8010675a:	85 c0                	test   %eax,%eax
8010675c:	75 ba                	jne    80106718 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010675e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106764:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010676a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106770:	39 f3                	cmp    %esi,%ebx
80106772:	72 db                	jb     8010674f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106774:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106777:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010677a:	5b                   	pop    %ebx
8010677b:	5e                   	pop    %esi
8010677c:	5f                   	pop    %edi
8010677d:	5d                   	pop    %ebp
8010677e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010677f:	83 ec 0c             	sub    $0xc,%esp
80106782:	68 86 73 10 80       	push   $0x80107386
80106787:	e8 e4 9b ff ff       	call   80100370 <panic>
8010678c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106790 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106796:	e8 a5 cf ff ff       	call   80103740 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010679b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801067a1:	31 c9                	xor    %ecx,%ecx
801067a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067a8:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
801067af:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067b6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067bb:	31 c9                	xor    %ecx,%ecx
801067bd:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067c4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067c9:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067d0:	31 c9                	xor    %ecx,%ecx
801067d2:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
801067d9:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067e0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067e5:	31 c9                	xor    %ecx,%ecx
801067e7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067ee:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801067f5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801067fa:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106801:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106808:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010680f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106816:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010681d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106824:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010682b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106832:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106839:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106840:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106847:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010684e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106855:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010685c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106863:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010686a:	05 f0 27 11 80       	add    $0x801127f0,%eax
8010686f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106873:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106877:	c1 e8 10             	shr    $0x10,%eax
8010687a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010687e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106881:	0f 01 10             	lgdtl  (%eax)
}
80106884:	c9                   	leave  
80106885:	c3                   	ret    
80106886:	8d 76 00             	lea    0x0(%esi),%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106890 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106890:	a1 a4 54 11 80       	mov    0x801154a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
80106898:	05 00 00 00 80       	add    $0x80000000,%eax
8010689d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801068a0:	5d                   	pop    %ebp
801068a1:	c3                   	ret    
801068a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
801068b6:	83 ec 1c             	sub    $0x1c,%esp
801068b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068bc:	85 f6                	test   %esi,%esi
801068be:	0f 84 cd 00 00 00    	je     80106991 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801068c4:	8b 46 08             	mov    0x8(%esi),%eax
801068c7:	85 c0                	test   %eax,%eax
801068c9:	0f 84 dc 00 00 00    	je     801069ab <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801068cf:	8b 7e 04             	mov    0x4(%esi),%edi
801068d2:	85 ff                	test   %edi,%edi
801068d4:	0f 84 c4 00 00 00    	je     8010699e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801068da:	e8 41 d9 ff ff       	call   80104220 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068df:	e8 dc cd ff ff       	call   801036c0 <mycpu>
801068e4:	89 c3                	mov    %eax,%ebx
801068e6:	e8 d5 cd ff ff       	call   801036c0 <mycpu>
801068eb:	89 c7                	mov    %eax,%edi
801068ed:	e8 ce cd ff ff       	call   801036c0 <mycpu>
801068f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068f5:	83 c7 08             	add    $0x8,%edi
801068f8:	e8 c3 cd ff ff       	call   801036c0 <mycpu>
801068fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106900:	83 c0 08             	add    $0x8,%eax
80106903:	ba 67 00 00 00       	mov    $0x67,%edx
80106908:	c1 e8 18             	shr    $0x18,%eax
8010690b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106912:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106919:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106920:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106927:	83 c1 08             	add    $0x8,%ecx
8010692a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106930:	c1 e9 10             	shr    $0x10,%ecx
80106933:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106939:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010693e:	e8 7d cd ff ff       	call   801036c0 <mycpu>
80106943:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010694a:	e8 71 cd ff ff       	call   801036c0 <mycpu>
8010694f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106954:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106958:	e8 63 cd ff ff       	call   801036c0 <mycpu>
8010695d:	8b 56 08             	mov    0x8(%esi),%edx
80106960:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106966:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106969:	e8 52 cd ff ff       	call   801036c0 <mycpu>
8010696e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106972:	b8 28 00 00 00       	mov    $0x28,%eax
80106977:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010697a:	8b 46 04             	mov    0x4(%esi),%eax
8010697d:	05 00 00 00 80       	add    $0x80000000,%eax
80106982:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106985:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106988:	5b                   	pop    %ebx
80106989:	5e                   	pop    %esi
8010698a:	5f                   	pop    %edi
8010698b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010698c:	e9 cf d8 ff ff       	jmp    80104260 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106991:	83 ec 0c             	sub    $0xc,%esp
80106994:	68 f6 79 10 80       	push   $0x801079f6
80106999:	e8 d2 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010699e:	83 ec 0c             	sub    $0xc,%esp
801069a1:	68 21 7a 10 80       	push   $0x80107a21
801069a6:	e8 c5 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801069ab:	83 ec 0c             	sub    $0xc,%esp
801069ae:	68 0c 7a 10 80       	push   $0x80107a0c
801069b3:	e8 b8 99 ff ff       	call   80100370 <panic>
801069b8:	90                   	nop
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 75 10             	mov    0x10(%ebp),%esi
801069cc:	8b 45 08             	mov    0x8(%ebp),%eax
801069cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801069db:	77 49                	ja     80106a26 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801069dd:	e8 9e ba ff ff       	call   80102480 <kalloc>
  memset(mem, 0, PGSIZE);
801069e2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801069e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069e7:	68 00 10 00 00       	push   $0x1000
801069ec:	6a 00                	push   $0x0
801069ee:	50                   	push   %eax
801069ef:	e8 0c da ff ff       	call   80104400 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801069f4:	58                   	pop    %eax
801069f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a00:	5a                   	pop    %edx
80106a01:	6a 06                	push   $0x6
80106a03:	50                   	push   %eax
80106a04:	31 d2                	xor    %edx,%edx
80106a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a09:	e8 52 fc ff ff       	call   80106660 <mappages>
  memmove(mem, init, sz);
80106a0e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a11:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a14:	83 c4 10             	add    $0x10,%esp
80106a17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a1d:	5b                   	pop    %ebx
80106a1e:	5e                   	pop    %esi
80106a1f:	5f                   	pop    %edi
80106a20:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a21:	e9 8a da ff ff       	jmp    801044b0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a26:	83 ec 0c             	sub    $0xc,%esp
80106a29:	68 35 7a 10 80       	push   $0x80107a35
80106a2e:	e8 3d 99 ff ff       	call   80100370 <panic>
80106a33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a50:	0f 85 91 00 00 00    	jne    80106ae7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a56:	8b 75 18             	mov    0x18(%ebp),%esi
80106a59:	31 db                	xor    %ebx,%ebx
80106a5b:	85 f6                	test   %esi,%esi
80106a5d:	75 1a                	jne    80106a79 <loaduvm+0x39>
80106a5f:	eb 6f                	jmp    80106ad0 <loaduvm+0x90>
80106a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a77:	76 57                	jbe    80106ad0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a79:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7f:	31 c9                	xor    %ecx,%ecx
80106a81:	01 da                	add    %ebx,%edx
80106a83:	e8 58 fb ff ff       	call   801065e0 <walkpgdir>
80106a88:	85 c0                	test   %eax,%eax
80106a8a:	74 4e                	je     80106ada <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106a91:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106a9b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106aa1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106aa4:	01 d9                	add    %ebx,%ecx
80106aa6:	05 00 00 00 80       	add    $0x80000000,%eax
80106aab:	57                   	push   %edi
80106aac:	51                   	push   %ecx
80106aad:	50                   	push   %eax
80106aae:	ff 75 10             	pushl  0x10(%ebp)
80106ab1:	e8 8a ae ff ff       	call   80101940 <readi>
80106ab6:	83 c4 10             	add    $0x10,%esp
80106ab9:	39 c7                	cmp    %eax,%edi
80106abb:	74 ab                	je     80106a68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106abd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106ada:	83 ec 0c             	sub    $0xc,%esp
80106add:	68 4f 7a 10 80       	push   $0x80107a4f
80106ae2:	e8 89 98 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106ae7:	83 ec 0c             	sub    $0xc,%esp
80106aea:	68 1c 7b 10 80       	push   $0x80107b1c
80106aef:	e8 7c 98 ff ff       	call   80100370 <panic>
80106af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b0c:	85 ff                	test   %edi,%edi
80106b0e:	0f 88 ca 00 00 00    	js     80106bde <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106b14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b1a:	0f 82 82 00 00 00    	jb     80106ba2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b20:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b26:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b2c:	39 df                	cmp    %ebx,%edi
80106b2e:	77 43                	ja     80106b73 <allocuvm+0x73>
80106b30:	e9 bb 00 00 00       	jmp    80106bf0 <allocuvm+0xf0>
80106b35:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b38:	83 ec 04             	sub    $0x4,%esp
80106b3b:	68 00 10 00 00       	push   $0x1000
80106b40:	6a 00                	push   $0x0
80106b42:	50                   	push   %eax
80106b43:	e8 b8 d8 ff ff       	call   80104400 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b48:	58                   	pop    %eax
80106b49:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b4f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b54:	5a                   	pop    %edx
80106b55:	6a 06                	push   $0x6
80106b57:	50                   	push   %eax
80106b58:	89 da                	mov    %ebx,%edx
80106b5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5d:	e8 fe fa ff ff       	call   80106660 <mappages>
80106b62:	83 c4 10             	add    $0x10,%esp
80106b65:	85 c0                	test   %eax,%eax
80106b67:	78 47                	js     80106bb0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106b69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b6f:	39 df                	cmp    %ebx,%edi
80106b71:	76 7d                	jbe    80106bf0 <allocuvm+0xf0>
    mem = kalloc();
80106b73:	e8 08 b9 ff ff       	call   80102480 <kalloc>
    if(mem == 0){
80106b78:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106b7a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b7c:	75 ba                	jne    80106b38 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106b7e:	83 ec 0c             	sub    $0xc,%esp
80106b81:	68 6d 7a 10 80       	push   $0x80107a6d
80106b86:	e8 d5 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b8b:	83 c4 10             	add    $0x10,%esp
80106b8e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b91:	76 4b                	jbe    80106bde <allocuvm+0xde>
80106b93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b96:	8b 45 08             	mov    0x8(%ebp),%eax
80106b99:	89 fa                	mov    %edi,%edx
80106b9b:	e8 50 fb ff ff       	call   801066f0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106ba0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106bb0:	83 ec 0c             	sub    $0xc,%esp
80106bb3:	68 85 7a 10 80       	push   $0x80107a85
80106bb8:	e8 a3 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bbd:	83 c4 10             	add    $0x10,%esp
80106bc0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bc3:	76 0d                	jbe    80106bd2 <allocuvm+0xd2>
80106bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcb:	89 fa                	mov    %edi,%edx
80106bcd:	e8 1e fb ff ff       	call   801066f0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106bd2:	83 ec 0c             	sub    $0xc,%esp
80106bd5:	56                   	push   %esi
80106bd6:	e8 f5 b6 ff ff       	call   801022d0 <kfree>
      return 0;
80106bdb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106be1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106be3:	5b                   	pop    %ebx
80106be4:	5e                   	pop    %esi
80106be5:	5f                   	pop    %edi
80106be6:	5d                   	pop    %ebp
80106be7:	c3                   	ret    
80106be8:	90                   	nop
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106bf3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c00 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c06:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c09:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c0c:	39 d1                	cmp    %edx,%ecx
80106c0e:	73 10                	jae    80106c20 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c10:	5d                   	pop    %ebp
80106c11:	e9 da fa ff ff       	jmp    801066f0 <deallocuvm.part.0>
80106c16:	8d 76 00             	lea    0x0(%esi),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c20:	89 d0                	mov    %edx,%eax
80106c22:	5d                   	pop    %ebp
80106c23:	c3                   	ret    
80106c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	83 ec 0c             	sub    $0xc,%esp
80106c39:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c3c:	85 f6                	test   %esi,%esi
80106c3e:	74 59                	je     80106c99 <freevm+0x69>
80106c40:	31 c9                	xor    %ecx,%ecx
80106c42:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c47:	89 f0                	mov    %esi,%eax
80106c49:	e8 a2 fa ff ff       	call   801066f0 <deallocuvm.part.0>
80106c4e:	89 f3                	mov    %esi,%ebx
80106c50:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c56:	eb 0f                	jmp    80106c67 <freevm+0x37>
80106c58:	90                   	nop
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c60:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c63:	39 fb                	cmp    %edi,%ebx
80106c65:	74 23                	je     80106c8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c67:	8b 03                	mov    (%ebx),%eax
80106c69:	a8 01                	test   $0x1,%al
80106c6b:	74 f3                	je     80106c60 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c72:	83 ec 0c             	sub    $0xc,%esp
80106c75:	83 c3 04             	add    $0x4,%ebx
80106c78:	05 00 00 00 80       	add    $0x80000000,%eax
80106c7d:	50                   	push   %eax
80106c7e:	e8 4d b6 ff ff       	call   801022d0 <kfree>
80106c83:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c86:	39 fb                	cmp    %edi,%ebx
80106c88:	75 dd                	jne    80106c67 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c90:	5b                   	pop    %ebx
80106c91:	5e                   	pop    %esi
80106c92:	5f                   	pop    %edi
80106c93:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c94:	e9 37 b6 ff ff       	jmp    801022d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106c99:	83 ec 0c             	sub    $0xc,%esp
80106c9c:	68 a1 7a 10 80       	push   $0x80107aa1
80106ca1:	e8 ca 96 ff ff       	call   80100370 <panic>
80106ca6:	8d 76 00             	lea    0x0(%esi),%esi
80106ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cb0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	56                   	push   %esi
80106cb4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106cb5:	e8 c6 b7 ff ff       	call   80102480 <kalloc>
80106cba:	85 c0                	test   %eax,%eax
80106cbc:	74 6a                	je     80106d28 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cbe:	83 ec 04             	sub    $0x4,%esp
80106cc1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cc3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cc8:	68 00 10 00 00       	push   $0x1000
80106ccd:	6a 00                	push   $0x0
80106ccf:	50                   	push   %eax
80106cd0:	e8 2b d7 ff ff       	call   80104400 <memset>
80106cd5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106cd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106cdb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106cde:	83 ec 08             	sub    $0x8,%esp
80106ce1:	8b 13                	mov    (%ebx),%edx
80106ce3:	ff 73 0c             	pushl  0xc(%ebx)
80106ce6:	50                   	push   %eax
80106ce7:	29 c1                	sub    %eax,%ecx
80106ce9:	89 f0                	mov    %esi,%eax
80106ceb:	e8 70 f9 ff ff       	call   80106660 <mappages>
80106cf0:	83 c4 10             	add    $0x10,%esp
80106cf3:	85 c0                	test   %eax,%eax
80106cf5:	78 19                	js     80106d10 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cf7:	83 c3 10             	add    $0x10,%ebx
80106cfa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d00:	75 d6                	jne    80106cd8 <setupkvm+0x28>
80106d02:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d07:	5b                   	pop    %ebx
80106d08:	5e                   	pop    %esi
80106d09:	5d                   	pop    %ebp
80106d0a:	c3                   	ret    
80106d0b:	90                   	nop
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106d10:	83 ec 0c             	sub    $0xc,%esp
80106d13:	56                   	push   %esi
80106d14:	e8 17 ff ff ff       	call   80106c30 <freevm>
      return 0;
80106d19:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106d1f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106d21:	5b                   	pop    %ebx
80106d22:	5e                   	pop    %esi
80106d23:	5d                   	pop    %ebp
80106d24:	c3                   	ret    
80106d25:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106d28:	31 c0                	xor    %eax,%eax
80106d2a:	eb d8                	jmp    80106d04 <setupkvm+0x54>
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d30 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d36:	e8 75 ff ff ff       	call   80106cb0 <setupkvm>
80106d3b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
80106d40:	05 00 00 00 80       	add    $0x80000000,%eax
80106d45:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106d48:	c9                   	leave  
80106d49:	c3                   	ret    
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d51:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d53:	89 e5                	mov    %esp,%ebp
80106d55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5e:	e8 7d f8 ff ff       	call   801065e0 <walkpgdir>
  if(pte == 0)
80106d63:	85 c0                	test   %eax,%eax
80106d65:	74 05                	je     80106d6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106d67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106d6a:	c9                   	leave  
80106d6b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106d6c:	83 ec 0c             	sub    $0xc,%esp
80106d6f:	68 b2 7a 10 80       	push   $0x80107ab2
80106d74:	e8 f7 95 ff ff       	call   80100370 <panic>
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106d89:	e8 22 ff ff ff       	call   80106cb0 <setupkvm>
80106d8e:	85 c0                	test   %eax,%eax
80106d90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d93:	0f 84 c5 00 00 00    	je     80106e5e <copyuvm+0xde>
    return 0;
  //changed for p5
  for(i = 4096; i < sz; i += PGSIZE){
80106d99:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
80106da0:	0f 86 9a 00 00 00    	jbe    80106e40 <copyuvm+0xc0>
80106da6:	bf 00 10 00 00       	mov    $0x1000,%edi
80106dab:	eb 45                	jmp    80106df2 <copyuvm+0x72>
80106dad:	8d 76 00             	lea    0x0(%esi),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106db0:	83 ec 04             	sub    $0x4,%esp
80106db3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106db9:	68 00 10 00 00       	push   $0x1000
80106dbe:	53                   	push   %ebx
80106dbf:	50                   	push   %eax
80106dc0:	e8 eb d6 ff ff       	call   801044b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106dc5:	58                   	pop    %eax
80106dc6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106dcc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dd1:	5a                   	pop    %edx
80106dd2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106dd5:	50                   	push   %eax
80106dd6:	89 fa                	mov    %edi,%edx
80106dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ddb:	e8 80 f8 ff ff       	call   80106660 <mappages>
80106de0:	83 c4 10             	add    $0x10,%esp
80106de3:	85 c0                	test   %eax,%eax
80106de5:	78 69                	js     80106e50 <copyuvm+0xd0>
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  //changed for p5
  for(i = 4096; i < sz; i += PGSIZE){
80106de7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ded:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106df0:	76 4e                	jbe    80106e40 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106df2:	8b 45 08             	mov    0x8(%ebp),%eax
80106df5:	31 c9                	xor    %ecx,%ecx
80106df7:	89 fa                	mov    %edi,%edx
80106df9:	e8 e2 f7 ff ff       	call   801065e0 <walkpgdir>
80106dfe:	85 c0                	test   %eax,%eax
80106e00:	74 6d                	je     80106e6f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e02:	8b 00                	mov    (%eax),%eax
80106e04:	a8 01                	test   $0x1,%al
80106e06:	74 5a                	je     80106e62 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e08:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e0a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 4096; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e0f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106e18:	e8 63 b6 ff ff       	call   80102480 <kalloc>
80106e1d:	85 c0                	test   %eax,%eax
80106e1f:	89 c6                	mov    %eax,%esi
80106e21:	75 8d                	jne    80106db0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106e23:	83 ec 0c             	sub    $0xc,%esp
80106e26:	ff 75 e0             	pushl  -0x20(%ebp)
80106e29:	e8 02 fe ff ff       	call   80106c30 <freevm>
  return 0;
80106e2e:	83 c4 10             	add    $0x10,%esp
80106e31:	31 c0                	xor    %eax,%eax
}
80106e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e36:	5b                   	pop    %ebx
80106e37:	5e                   	pop    %esi
80106e38:	5f                   	pop    %edi
80106e39:	5d                   	pop    %ebp
80106e3a:	c3                   	ret    
80106e3b:	90                   	nop
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  //changed for p5
  for(i = 4096; i < sz; i += PGSIZE){
80106e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e46:	5b                   	pop    %ebx
80106e47:	5e                   	pop    %esi
80106e48:	5f                   	pop    %edi
80106e49:	5d                   	pop    %ebp
80106e4a:	c3                   	ret    
80106e4b:	90                   	nop
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	56                   	push   %esi
80106e54:	e8 77 b4 ff ff       	call   801022d0 <kfree>
      goto bad;
80106e59:	83 c4 10             	add    $0x10,%esp
80106e5c:	eb c5                	jmp    80106e23 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106e5e:	31 c0                	xor    %eax,%eax
80106e60:	eb d1                	jmp    80106e33 <copyuvm+0xb3>
  //changed for p5
  for(i = 4096; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106e62:	83 ec 0c             	sub    $0xc,%esp
80106e65:	68 d6 7a 10 80       	push   $0x80107ad6
80106e6a:	e8 01 95 ff ff       	call   80100370 <panic>
  if((d = setupkvm()) == 0)
    return 0;
  //changed for p5
  for(i = 4096; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106e6f:	83 ec 0c             	sub    $0xc,%esp
80106e72:	68 bc 7a 10 80       	push   $0x80107abc
80106e77:	e8 f4 94 ff ff       	call   80100370 <panic>
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e81:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e83:	89 e5                	mov    %esp,%ebp
80106e85:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8e:	e8 4d f7 ff ff       	call   801065e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e93:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106e95:	89 c2                	mov    %eax,%edx
80106e97:	83 e2 05             	and    $0x5,%edx
80106e9a:	83 fa 05             	cmp    $0x5,%edx
80106e9d:	75 11                	jne    80106eb0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106e9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106ea4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ea5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106eaa:	c3                   	ret    
80106eab:	90                   	nop
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106eb0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106eb2:	c9                   	leave  
80106eb3:	c3                   	ret    
80106eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ec0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ecf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ed2:	85 db                	test   %ebx,%ebx
80106ed4:	75 40                	jne    80106f16 <copyout+0x56>
80106ed6:	eb 70                	jmp    80106f48 <copyout+0x88>
80106ed8:	90                   	nop
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ee0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ee3:	89 f1                	mov    %esi,%ecx
80106ee5:	29 d1                	sub    %edx,%ecx
80106ee7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106eed:	39 d9                	cmp    %ebx,%ecx
80106eef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ef2:	29 f2                	sub    %esi,%edx
80106ef4:	83 ec 04             	sub    $0x4,%esp
80106ef7:	01 d0                	add    %edx,%eax
80106ef9:	51                   	push   %ecx
80106efa:	57                   	push   %edi
80106efb:	50                   	push   %eax
80106efc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106eff:	e8 ac d5 ff ff       	call   801044b0 <memmove>
    len -= n;
    buf += n;
80106f04:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f07:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f0a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f10:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f12:	29 cb                	sub    %ecx,%ebx
80106f14:	74 32                	je     80106f48 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f16:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f18:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f1e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f24:	56                   	push   %esi
80106f25:	ff 75 08             	pushl  0x8(%ebp)
80106f28:	e8 53 ff ff ff       	call   80106e80 <uva2ka>
    if(pa0 == 0)
80106f2d:	83 c4 10             	add    $0x10,%esp
80106f30:	85 c0                	test   %eax,%eax
80106f32:	75 ac                	jne    80106ee0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f3c:	5b                   	pop    %ebx
80106f3d:	5e                   	pop    %esi
80106f3e:	5f                   	pop    %edi
80106f3f:	5d                   	pop    %ebp
80106f40:	c3                   	ret    
80106f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f4b:	31 c0                	xor    %eax,%eax
}
80106f4d:	5b                   	pop    %ebx
80106f4e:	5e                   	pop    %esi
80106f4f:	5f                   	pop    %edi
80106f50:	5d                   	pop    %ebp
80106f51:	c3                   	ret    
80106f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <mprotect>:

//below is additions for p5

// function makes entries to a page table "read only"
int mprotect(void *addr, int len){
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 0c             	sub    $0xc,%esp
80106f69:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *curproc = myproc();
80106f6c:	e8 ef c7 ff ff       	call   80103760 <myproc>
  
  //if addr is not part of an address space, returns -1
  if(len <= 0 || (int)addr+len*PGSIZE>curproc->sz){
80106f71:	85 f6                	test   %esi,%esi
80106f73:	0f 8e 8c 00 00 00    	jle    80107005 <mprotect+0xa5>
80106f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106f7c:	c1 e6 0c             	shl    $0xc,%esi
80106f7f:	89 c7                	mov    %eax,%edi
80106f81:	01 de                	add    %ebx,%esi
80106f83:	3b 30                	cmp    (%eax),%esi
80106f85:	77 7e                	ja     80107005 <mprotect+0xa5>
    cprintf("\nwrong len\n");
    return -1;
  }
  if((int)(((int) addr) % PGSIZE )  != 0){
80106f87:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80106f8d:	0f 85 89 00 00 00    	jne    8010701c <mprotect+0xbc>
    return -1;
  }
  
  pte_t *pte;
  int i;
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80106f93:	39 f3                	cmp    %esi,%ebx
80106f95:	7c 35                	jl     80106fcc <mprotect+0x6c>
80106f97:	eb 57                	jmp    80106ff0 <mprotect+0x90>
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
80106fa0:	8b 10                	mov    (%eax),%edx
80106fa2:	89 d1                	mov    %edx,%ecx
80106fa4:	83 e1 05             	and    $0x5,%ecx
80106fa7:	83 f9 05             	cmp    $0x5,%ecx
80106faa:	75 30                	jne    80106fdc <mprotect+0x7c>
      *pte = (*pte) & (~PTE_W);
      cprintf("\nPTE : 0x%p\n", pte);
80106fac:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;
  int i;
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
      *pte = (*pte) & (~PTE_W);
80106faf:	83 e2 fd             	and    $0xfffffffd,%edx
    return -1;
  }
  
  pte_t *pte;
  int i;
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80106fb2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
      *pte = (*pte) & (~PTE_W);
80106fb8:	89 10                	mov    %edx,(%eax)
      cprintf("\nPTE : 0x%p\n", pte);
80106fba:	50                   	push   %eax
80106fbb:	68 0c 7b 10 80       	push   $0x80107b0c
80106fc0:	e8 9b 96 ff ff       	call   80100660 <cprintf>
    return -1;
  }
  
  pte_t *pte;
  int i;
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80106fc5:	83 c4 10             	add    $0x10,%esp
80106fc8:	39 de                	cmp    %ebx,%esi
80106fca:	7e 24                	jle    80106ff0 <mprotect+0x90>
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
80106fcc:	8b 47 04             	mov    0x4(%edi),%eax
80106fcf:	31 c9                	xor    %ecx,%ecx
80106fd1:	89 da                	mov    %ebx,%edx
80106fd3:	e8 08 f6 ff ff       	call   801065e0 <walkpgdir>
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
80106fd8:	85 c0                	test   %eax,%eax
80106fda:	75 c4                	jne    80106fa0 <mprotect+0x40>
      *pte = (*pte) & (~PTE_W);
      cprintf("\nPTE : 0x%p\n", pte);
    }else{
      return -1;
80106fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
  }
  lcr3(V2P(curproc->pgdir));  
  return 0;
}
80106fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe4:	5b                   	pop    %ebx
80106fe5:	5e                   	pop    %esi
80106fe6:	5f                   	pop    %edi
80106fe7:	5d                   	pop    %ebp
80106fe8:	c3                   	ret    
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ff0:	8b 47 04             	mov    0x4(%edi),%eax
80106ff3:	05 00 00 00 80       	add    $0x80000000,%eax
80106ff8:	0f 22 d8             	mov    %eax,%cr3
80106ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    }else{
      return -1;
    }
  }
  lcr3(V2P(curproc->pgdir));  
  return 0;
80106ffe:	31 c0                	xor    %eax,%eax
}
80107000:	5b                   	pop    %ebx
80107001:	5e                   	pop    %esi
80107002:	5f                   	pop    %edi
80107003:	5d                   	pop    %ebp
80107004:	c3                   	ret    
int mprotect(void *addr, int len){
  struct proc *curproc = myproc();
  
  //if addr is not part of an address space, returns -1
  if(len <= 0 || (int)addr+len*PGSIZE>curproc->sz){
    cprintf("\nwrong len\n");
80107005:	83 ec 0c             	sub    $0xc,%esp
80107008:	68 f0 7a 10 80       	push   $0x80107af0
8010700d:	e8 4e 96 ff ff       	call   80100660 <cprintf>
    return -1;
80107012:	83 c4 10             	add    $0x10,%esp
80107015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010701a:	eb c5                	jmp    80106fe1 <mprotect+0x81>
  }
  if((int)(((int) addr) % PGSIZE )  != 0){
    cprintf("\nwrong addr %p\n", addr);
8010701c:	83 ec 08             	sub    $0x8,%esp
8010701f:	ff 75 08             	pushl  0x8(%ebp)
80107022:	68 fc 7a 10 80       	push   $0x80107afc
80107027:	e8 34 96 ff ff       	call   80100660 <cprintf>
    return -1;
8010702c:	83 c4 10             	add    $0x10,%esp
8010702f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107034:	eb ab                	jmp    80106fe1 <mprotect+0x81>
80107036:	8d 76 00             	lea    0x0(%esi),%esi
80107039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107040 <munprotect>:
  lcr3(V2P(curproc->pgdir));  
  return 0;
}

//makes the entry in page table readable and writable
int munprotect(void *addr, int len){
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *curproc = myproc();
8010704c:	e8 0f c7 ff ff       	call   80103760 <myproc>
  
  //if addr is not part of an address space, returns -1
  if(len <= 0 || (int)addr+len*PGSIZE>curproc->sz){
80107051:	85 f6                	test   %esi,%esi
80107053:	0f 8e 8c 00 00 00    	jle    801070e5 <munprotect+0xa5>
80107059:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010705c:	c1 e6 0c             	shl    $0xc,%esi
8010705f:	89 c7                	mov    %eax,%edi
80107061:	01 de                	add    %ebx,%esi
80107063:	3b 30                	cmp    (%eax),%esi
80107065:	77 7e                	ja     801070e5 <munprotect+0xa5>
    cprintf("\nwrong len\n");
    return -1;
  }
  if((int)(((int) addr) % PGSIZE )  != 0){
80107067:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010706d:	0f 85 89 00 00 00    	jne    801070fc <munprotect+0xbc>
  }

  pte_t *pte;
  int i;

  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80107073:	39 f3                	cmp    %esi,%ebx
80107075:	7c 35                	jl     801070ac <munprotect+0x6c>
80107077:	eb 57                	jmp    801070d0 <munprotect+0x90>
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
80107080:	8b 10                	mov    (%eax),%edx
80107082:	89 d1                	mov    %edx,%ecx
80107084:	83 e1 05             	and    $0x5,%ecx
80107087:	83 f9 05             	cmp    $0x5,%ecx
8010708a:	75 30                	jne    801070bc <munprotect+0x7c>
      *pte = (*pte) | (PTE_W);
      cprintf("\nPTE : 0x%p\n", pte);
8010708c:	83 ec 08             	sub    $0x8,%esp
  int i;

  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
      *pte = (*pte) | (PTE_W);
8010708f:	83 ca 02             	or     $0x2,%edx
  }

  pte_t *pte;
  int i;

  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80107092:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
      *pte = (*pte) | (PTE_W);
80107098:	89 10                	mov    %edx,(%eax)
      cprintf("\nPTE : 0x%p\n", pte);
8010709a:	50                   	push   %eax
8010709b:	68 0c 7b 10 80       	push   $0x80107b0c
801070a0:	e8 bb 95 ff ff       	call   80100660 <cprintf>
  }

  pte_t *pte;
  int i;

  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
801070a5:	83 c4 10             	add    $0x10,%esp
801070a8:	39 de                	cmp    %ebx,%esi
801070aa:	7e 24                	jle    801070d0 <munprotect+0x90>
    pte = walkpgdir(curproc->pgdir,(void*) i, 0);
801070ac:	8b 47 04             	mov    0x4(%edi),%eax
801070af:	31 c9                	xor    %ecx,%ecx
801070b1:	89 da                	mov    %ebx,%edx
801070b3:	e8 28 f5 ff ff       	call   801065e0 <walkpgdir>
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
801070b8:	85 c0                	test   %eax,%eax
801070ba:	75 c4                	jne    80107080 <munprotect+0x40>
      *pte = (*pte) | (PTE_W);
      cprintf("\nPTE : 0x%p\n", pte);
    }else{
      return -1;
801070bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
  }
  lcr3(V2P(curproc->pgdir));
  return 0;
}
801070c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c4:	5b                   	pop    %ebx
801070c5:	5e                   	pop    %esi
801070c6:	5f                   	pop    %edi
801070c7:	5d                   	pop    %ebp
801070c8:	c3                   	ret    
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d0:	8b 47 04             	mov    0x4(%edi),%eax
801070d3:	05 00 00 00 80       	add    $0x80000000,%eax
801070d8:	0f 22 d8             	mov    %eax,%cr3
801070db:	8d 65 f4             	lea    -0xc(%ebp),%esp
    }else{
      return -1;
    }
  }
  lcr3(V2P(curproc->pgdir));
  return 0;
801070de:	31 c0                	xor    %eax,%eax
}
801070e0:	5b                   	pop    %ebx
801070e1:	5e                   	pop    %esi
801070e2:	5f                   	pop    %edi
801070e3:	5d                   	pop    %ebp
801070e4:	c3                   	ret    
int munprotect(void *addr, int len){
  struct proc *curproc = myproc();
  
  //if addr is not part of an address space, returns -1
  if(len <= 0 || (int)addr+len*PGSIZE>curproc->sz){
    cprintf("\nwrong len\n");
801070e5:	83 ec 0c             	sub    $0xc,%esp
801070e8:	68 f0 7a 10 80       	push   $0x80107af0
801070ed:	e8 6e 95 ff ff       	call   80100660 <cprintf>
    return -1;
801070f2:	83 c4 10             	add    $0x10,%esp
801070f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070fa:	eb c5                	jmp    801070c1 <munprotect+0x81>
  }
  if((int)(((int) addr) % PGSIZE )  != 0){
    cprintf("\nwrong addr %p\n", addr);
801070fc:	83 ec 08             	sub    $0x8,%esp
801070ff:	ff 75 08             	pushl  0x8(%ebp)
80107102:	68 fc 7a 10 80       	push   $0x80107afc
80107107:	e8 54 95 ff ff       	call   80100660 <cprintf>
    return -1;
8010710c:	83 c4 10             	add    $0x10,%esp
8010710f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107114:	eb ab                	jmp    801070c1 <munprotect+0x81>
