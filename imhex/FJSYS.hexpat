#pragma author Arisu Wonderland
#pragma description FJSYS file format

#pragma magic [ 46 4A 53 59 53 00 00 00 ] @ 0x00
#pragma endian little

import std.mem;

u32 FILES_AMOUNT;
u32 FILENAME_TABLE_PTR;
u32 ITER_METADATA_ENTRY;

struct Header {
    char magic[8] [[name("Magic")]];

    u8* hdr_data_ptr : u32 [[name("Data pointer (first file)")]];
    u32 filename_table_size [[name("Filename table size")]];
    u32 files_amount [[name("Files amount")]];

    u8 unknown[64] [[hidden]]; // TODO: All zeros?

    FILES_AMOUNT = files_amount;
};

struct MetadataEntry {
    u32 filename_table_offset [[name("Offset in Filename table")]];
    u32 file_size [[name("File size (in bytes)")]];
    u8* data_ptr : u32 [[name("Data pointer")]];
    u32 [[hidden]]; // padding
} [[static]];

struct FilenameEntry {
    char filename[];
};

struct FilenameTable {
    FilenameEntry array[FILES_AMOUNT] [[inline]];
    u8 [[hidden]]; // padding
};

struct DataEntry {
    MetadataEntry ENTRY @ ITER_METADATA_ENTRY [[hidden]];
    char FILENAME[] @ FILENAME_TABLE_PTR + ENTRY.filename_table_offset [[hidden]];

    u8 data[ENTRY.file_size] @ addressof(ENTRY.data_ptr) [[inline]];

    ITER_METADATA_ENTRY += sizeof(ENTRY);
} [[name(FILENAME)]];

struct FJSYS {
    Header [[name("Header")]];
    MetadataEntry meta_table[FILES_AMOUNT] [[name("Metadata table")]];
    FilenameTable filename_table[[name("Filename table")]];

    FILENAME_TABLE_PTR = addressof(filename_table);
    ITER_METADATA_ENTRY = addressof(meta_table[0]);

    DataEntry data[FILES_AMOUNT] [[name("Data")]];
};

FJSYS fjsys @ 0x00;
