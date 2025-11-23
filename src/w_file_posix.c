//
// Copyright(C) 2025 Mohammed Isam
// Copyright(C) 1993-1996 Id Software, Inc.
// Copyright(C) 2005-2014 Simon Howard
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// DESCRIPTION:
//	WAD I/O functions.
//

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>

#include "m_misc.h"
#include "w_file.h"
#include "z_zone.h"

extern wad_file_class_t posix_wad_file;

static wad_file_t *W_Posix_OpenFile(char *path)
{
    wad_file_t *result;
    int fd;
    unsigned int length;
    void *map;

    fd = open(path, O_RDONLY);

    if (fd < 0)
    {
        return NULL;
    }

    length = lseek(fd, 0, SEEK_END);
    lseek(fd, 0, SEEK_SET);
    map = mmap(0, length, PROT_READ, MAP_SHARED, fd, 0);
    close(fd);

    if (map == MAP_FAILED)
    {
        return NULL;
    }

    // Create a new wad_file_t to hold the file handle.

    result = Z_Malloc(sizeof(wad_file_t), PU_STATIC, 0);
    result->file_class = &posix_wad_file;
    result->mapped = map;
    result->length = length;

    return result;
}

static void W_Posix_CloseFile(wad_file_t *wad)
{
    Z_Free(wad);
}

// Read data from the specified position in the file into the 
// provided buffer.  Returns the number of bytes read.

size_t W_Posix_Read(wad_file_t *wad, unsigned int offset,
                    void *buffer, size_t buffer_len)
{
    // Read into the buffer.

    memcpy(buffer, (char *)wad->mapped + offset, buffer_len);

    return buffer_len;
}


wad_file_class_t posix_wad_file = 
{
    W_Posix_OpenFile,
    W_Posix_CloseFile,
    W_Posix_Read,
};


