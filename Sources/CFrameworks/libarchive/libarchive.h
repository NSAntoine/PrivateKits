//
//  libarchive.h
//  
//
//  Created by Serena on 21/10/2022
//
	

#ifndef libarchive_h
#define libarchive_h

#include "archive_entry.h"
#include "archive.h"


//#ifndef NO_CREATE
//static char buff[16384];
//
//static void
//create(const char *filename, int compress, const char **argv)
//{
//    struct archive *a;
//    struct archive_entry *entry;
//    ssize_t len;
//    int fd;
//
//    a = archive_write_new();
//    switch (compress) {
//#ifndef NO_BZIP2_CREATE
//        case 'j': case 'y':
//            archive_write_add_filter_bzip2(a);
//            break;
//#endif
//#ifndef NO_COMPRESS_CREATE
//        case 'Z':
//            archive_write_add_filter_compress(a);
//            break;
//#endif
//#ifndef NO_GZIP_CREATE
//        case 'z':
//            archive_write_add_filter_gzip(a);
//            break;
//#endif
//        default:
//            archive_write_add_filter_none(a);
//            break;
//    }
//    archive_write_set_format_ustar(a);
//    if (filename != NULL && strcmp(filename, "-") == 0)
//        filename = NULL;
//    archive_write_open_filename(a, filename);
//
//    while (*argv != NULL) {
//        struct archive *disk = archive_read_disk_new();
//#ifndef NO_LOOKUP
//        archive_read_disk_set_standard_lookup(disk);
//#endif
//        int r;
//
//        r = archive_read_disk_open(disk, *argv);
//        if (r != ARCHIVE_OK) {
//            errmsg(archive_error_string(disk));
//            errmsg("\n");
//            exit(1);
//        }
//
//        for (;;) {
//            int needcr = 0;
//
//            entry = archive_entry_new();
//            r = archive_read_next_header2(disk, entry);
//            if (r == ARCHIVE_EOF)
//                break;
//            if (r != ARCHIVE_OK) {
//                errmsg(archive_error_string(disk));
//                errmsg("\n");
//                exit(1);
//            }
//            archive_read_disk_descend(disk);
//            if (verbose) {
//                msg("a ");
//                msg(archive_entry_pathname(entry));
//                needcr = 1;
//            }
//            r = archive_write_header(a, entry);
//            if (r < ARCHIVE_OK) {
//                errmsg(": ");
//                errmsg(archive_error_string(a));
//                needcr = 1;
//            }
//            if (r == ARCHIVE_FATAL)
//                exit(1);
//            if (r > ARCHIVE_FAILED) {
//#if 0
//                /* Ideally, we would be able to use
//                 * the same code to copy a body from
//                 * an archive_read_disk to an
//                 * archive_write that we use for
//                 * copying data from an archive_read
//                 * to an archive_write_disk.
//                 * Unfortunately, this doesn't quite
//                 * work yet. */
//                copy_data(disk, a);
//#else
//                /* For now, we use a simpler loop to copy data
//                 * into the target archive. */
//                fd = open(archive_entry_sourcepath(entry), O_RDONLY);
//                len = read(fd, buff, sizeof(buff));
//                while (len > 0) {
//                    archive_write_data(a, buff, len);
//                    len = read(fd, buff, sizeof(buff));
//                }
//                close(fd);
//#endif
//            }
//            archive_entry_free(entry);
//            if (needcr)
//                msg("\n");
//        }
//        archive_read_close(disk);
//        archive_read_free(disk);
//        argv++;
//    }
//    archive_write_close(a);
//    archive_write_free(a);
//}
//#endif
//

#endif /* libarchive_h */
