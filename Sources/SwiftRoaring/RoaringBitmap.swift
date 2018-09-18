import croaring

public typealias RoaringStatistics = roaring_statistics_t

public class RoaringBitmap: Sequence {
    var ptr: UnsafeMutablePointer<roaring_bitmap_t>
    
    /////////////////////////////////////////////////////////////////////////////
    ///                             CONSTRUCTORS                              ///
    /////////////////////////////////////////////////////////////////////////////
    /**
    * Creates a new bitmap (initially empty)
    */
    public init() {
        self.ptr = croaring.roaring_bitmap_create()!
    }

    /**
    * Add all the values between min (included) and max (excluded) that are at a
    * distance k*step from min.
    */
    public init(min: UInt64, max: UInt64, step: UInt32) {
        self.ptr = croaring.roaring_bitmap_from_range(min, max, step)!
    }

    /**
    * Creates a new bitmap (initially empty) with a provided
    * container-storage capacity (it is a performance hint).
    */
    public init(capacity: UInt32) {
        self.ptr = croaring.roaring_bitmap_create_with_capacity(capacity)!
    }

    /**
    * Creates a new bitmap from a pointer of uint32_t integers
    */
    public init(vals: [UInt32]) {
        let ptr: UnsafeMutablePointer = UnsafeMutablePointer(mutating: vals)
        self.ptr = croaring.roaring_bitmap_of_ptr(vals.count, ptr)!
    }

    /////////////////////////////////////////////////////////////////////////////
    ///                             OPERATORS                                 ///
    /////////////////////////////////////////////////////////////////////////////

    /**
    * Computes the intersection between two bitmaps and returns new bitmap. The
    * caller is
    * responsible for memory management.
    *
    */
    public func and(x: RoaringBitmap) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_and(self.ptr, x.ptr)
        return x2

    }

    /**
    * Computes the size of the intersection between two bitmaps.
    *
    */
    public func andCardinality(x: RoaringBitmap) -> UInt64 {
        return croaring.roaring_bitmap_and_cardinality(self.ptr, x.ptr)

    }

    /**
    * Check whether two bitmaps intersect.
    *
    */
    public func intersect(x: RoaringBitmap) -> Bool {
        return croaring.roaring_bitmap_intersect(self.ptr, x.ptr)

    }

    /**
    * Computes the Jaccard index between two bitmaps. (Also known as the Tanimoto
    * distance,
    * or the Jaccard similarity coefficient)
    *
    * The Jaccard index is undefined if both bitmaps are empty.
    *
    */
    public func jaccardIndex(x: RoaringBitmap) -> Double {
        return croaring.roaring_bitmap_jaccard_index(self.ptr, x.ptr)

    }

    /**
    * Computes the size of the union between two bitmaps.
    *
    */
    public func orCardinality(x: RoaringBitmap) -> UInt64 {
        return croaring.roaring_bitmap_or_cardinality(self.ptr, x.ptr)

    }

    /**
    * Computes the size of the difference (andnot) between two bitmaps.
    *
    */
    public func andNotCardinality(x: RoaringBitmap) -> UInt64 {
        return croaring.roaring_bitmap_andnot_cardinality(self.ptr, x.ptr)

    }

    /**
    * Computes the size of the symmetric difference (andnot) between two bitmaps.
    *
    */
    public func xorCardinality(x: RoaringBitmap) -> UInt64 {
        return croaring.roaring_bitmap_xor_cardinality(self.ptr, x.ptr)

    }

    /**
    * Inplace version modifies x1, x1 == x2 is allowed
    */
    public func inplace(x: RoaringBitmap) {
        croaring.roaring_bitmap_and_inplace(self.ptr, x.ptr)

    }

    /**
    * Computes the union between two bitmaps and returns new bitmap. The caller is
    * responsible for memory management.
    */
    public func or(x: RoaringBitmap) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_or(self.ptr, x.ptr)
        return x2

    }

    /**
    * Inplace version of roaring_bitmap_or, modifies x1. TDOO: decide whether x1 ==
    *x2 ok
    *
    */
    public func orInplace(x: RoaringBitmap) {
        croaring.roaring_bitmap_or_inplace(self.ptr, x.ptr)

    }

    /**
    * Compute the union of 'number' bitmaps. See also roaring_bitmap_or_many_heap.
    * Caller is responsible for freeing the
    * result.
    *
    */
    public func orMany(xs: [RoaringBitmap]) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        var ptrArray: [UnsafePointer<roaring_bitmap_t>?] = []
        for x in xs {
            ptrArray.append(x.ptr)
        }
        ptrArray.append(self.ptr)
        let ptrArrayPtr: UnsafeMutablePointer = UnsafeMutablePointer(mutating: ptrArray)
        x2.ptr = croaring.roaring_bitmap_or_many(ptrArray.count, ptrArrayPtr)
        return x2

    }

    /**
    * Compute the union of 'number' bitmaps using a heap. This can
    * sometimes be faster than roaring_bitmap_or_many which uses
    * a naive algorithm. Caller is responsible for freeing the
    * result.
    *
    */
    public func orManyHeap(xs: [RoaringBitmap]) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        var ptrArray: [UnsafePointer<roaring_bitmap_t>?] = []
        for x in xs {
            ptrArray.append(x.ptr)
        }
        ptrArray.append(self.ptr)
        let ptrArrayPtr: UnsafeMutablePointer = UnsafeMutablePointer(mutating: ptrArray)
        x2.ptr = croaring.roaring_bitmap_or_many_heap(UInt32(ptrArray.count), ptrArrayPtr)
        return x2

    }

    /**
    * Computes the symmetric difference (xor) between two bitmaps
    * and returns new bitmap. The caller is responsible for memory management.
    */
    public func xor(x: RoaringBitmap) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_xor(self.ptr, x.ptr)
        return x2

    }

    /**
    * Inplace version of roaring_bitmap_xor, modifies x1. x1 != x2.
    *
    */
    public func xorInplace(x: RoaringBitmap) {
        croaring.roaring_bitmap_xor_inplace(self.ptr, x.ptr)

    }

    /**
    * Compute the xor of 'number' bitmaps.
    * Caller is responsible for freeing the
    * result.
    *
    */
    public func xorMany(xs: [RoaringBitmap]) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        var ptrArray: [UnsafePointer<roaring_bitmap_t>?] = []
        for x in xs {
            ptrArray.append(x.ptr)
        }
        ptrArray.append(self.ptr)
        let ptrArrayPtr: UnsafeMutablePointer = UnsafeMutablePointer(mutating: ptrArray)
        x2.ptr = croaring.roaring_bitmap_xor_many(ptrArray.count, ptrArrayPtr)
        return x2

    }


    /**
    * Computes the  difference (andnot) between two bitmaps
    * and returns new bitmap. The caller is responsible for memory management.
    */
    public func andNot(x: RoaringBitmap) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_andnot(self.ptr, x.ptr)
        return x2

    }

    /**
    * Inplace version of roaring_bitmap_andnot, modifies x1. x1 != x2.
    *
    */
    public func andNotInplace(x: RoaringBitmap) {
        croaring.roaring_bitmap_andnot_inplace(self.ptr, x.ptr)

    }


    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////


    /**
    * Copies a  bitmap. This does memory allocation. The caller is responsible for
    * memory management.
    *
    */
    public func copy() -> RoaringBitmap {
        let cpy = RoaringBitmap()
        cpy.ptr = croaring.roaring_bitmap_copy(self.ptr)
        return cpy
    }

    /**
    * Copies a  bitmap from src to dest. It is assumed that the pointer dest
    * is to an already allocated bitmap. The content of the dest bitmap is
    * freed/deleted.
    *
    * It might be preferable and simpler to call roaring_bitmap_copy except
    * that roaring_bitmap_overwrite can save on memory allocations.
    *
    */
    // func overwrite(dest: RoaringBitmap) -> Bool {
    //     return croaring.roaring_bitmap_overwrite(dest.ptr, self.ptr)
    // }

    /**
    * Add value x
    *
    */
    public func add(x:UInt32) {
        croaring.roaring_bitmap_add(self.ptr, x)
    }

    /**
    * Add value n_args from pointer vals, faster than repeatedly calling
    * roaring_bitmap_add
    *
    */
    public func addMany(n_args: size_t, vals: inout [UInt32]) {
        croaring.roaring_bitmap_add_many(self.ptr, n_args, &vals)
    }

    /**
    * Add value x
    * Returns true if a new value was added, false if the value was already existing.
    */
    public func addCheck(x:UInt32) -> Bool {
        return croaring.roaring_bitmap_add_checked(self.ptr, x)
    }

    /**
    * Add all values in range [min, max]
    */
    public func addRangeClosed(min: UInt32, max: UInt32) {
        croaring.roaring_bitmap_add_range_closed(self.ptr, min, max)
    }

    /**
    * Add all values in range [min, max)
    */
    public func addRange(min: UInt64, max: UInt64) {
        croaring.roaring_bitmap_add_range(self.ptr, min, max)
    }

    /**
    * Remove value x
    *
    */
    public func remove(x:UInt32) {
        croaring.roaring_bitmap_remove(self.ptr, x)
    }

    /** Remove all values in range [min, max] */
    public func removeRangeClosed(min: UInt32, max: UInt32) {
        croaring.roaring_bitmap_remove_range_closed(self.ptr, min, max)
    }

    /** Remove all values in range [min, max) */
    public func removeRange(min: UInt64, max: UInt64) {
        croaring.roaring_bitmap_remove_range(self.ptr, min, max)
    }

    // /** Remove multiple values */
    // func removeMany(n_args: size_t, vals: [UInt32]) {
    //    let ptr: UnsafeMutablePointer = UnsafeMutablePointer(mutating: vals)
    //     croaring.roaring_bitmap_remove_many(self.ptr, n_args, ptr)
    // }

    /**
    * Remove value x
    * Returns true if a new value was removed, false if the value was not existing.
    */
    public func removeCheck(x:UInt32) -> Bool {
        return croaring.roaring_bitmap_remove_checked(self.ptr, x)
    }

    /**
    * Frees the memory.
    */
    public func free() {
        croaring.roaring_bitmap_free(self.ptr)
    }

    /**
    * Empties the bitmap.
    */
    public func clear() {
        croaring.roaring_bitmap_clear(self.ptr)
    }

    /**
    * Get the cardinality of the bitmap (number of elements).
    */
    public func count() -> UInt64 {
        return croaring.roaring_bitmap_get_cardinality(self.ptr)
    }

    /**
    * Check if value x is present
    */
    public func contains(x: UInt32) -> Bool {
        return croaring.roaring_bitmap_contains(self.ptr, x)
    }

    /**
    * Check whether a range of values from range_start (included) to range_end (excluded) is present
    */
    public func containsRange(start: UInt64, end: UInt64) -> Bool {
        return croaring.roaring_bitmap_contains_range(self.ptr, start, end)
    }
    
    public func isEmpty() -> Bool {
        return croaring.roaring_bitmap_is_empty(self.ptr)
    }
       
    /**
    * Print the content of the bitmap.
    */
    public func print() {
        croaring.roaring_bitmap_printf(self.ptr)
    }

    /**
    * Describe the inner structure of the bitmap.
    */
    public func describe() {
        croaring.roaring_bitmap_printf_describe(self.ptr)
    }

    /**
    * Convert the bitmap to an array. Write the output to "ans",
    * caller is responsible to ensure that there is enough memory
    * allocated
    * (e.g., ans = malloc(roaring_bitmap_get_cardinality(mybitmap)
    *   * sizeof(uint32_t))
    */
    public func toArray() -> [UInt32] {
        let array: [UInt32] = []
        let arrayPtr: UnsafeMutablePointer = UnsafeMutablePointer(mutating: array)
        croaring.roaring_bitmap_to_uint32_array(self.ptr, arrayPtr)
        return array
    }


    // /**
    // * Convert the bitmap to an array from "offset" by "limit". Write the output to "ans".
    // * so, you can get data in paging.
    // * caller is responsible to ensure that there is enough memory
    // * allocated
    // * (e.g., ans = malloc(roaring_bitmap_get_cardinality(limit)
    // *   * sizeof(uint32_t))
    // * Return false in case of failure (e.g., insufficient memory)
    // */
    // public func toArrayRange(offset: size_t, limit: size_t) -> [UInt32] {
    //     let array: [UInt32] = []
    //     _ = croaring.roaring_bitmap_range_uint32_array(self.ptr, offset, limit, array)
    //     return array
    // }

    /**
    *  Remove run-length encoding even when it is more space efficient
    *  return whether a change was applied
    */
    
    public func removeRunCompression() -> Bool {
        return croaring.roaring_bitmap_remove_run_compression(self.ptr)
    }
    

    /** convert array and bitmap containers to run containers when it is more
    * efficient;
    * also convert from run containers when more space efficient.  Returns
    * true if the result has at least one run container.
    * Additional savings might be possible by calling shrinkToFit().
    */
    public func runOptimize() -> Bool {
        return croaring.roaring_bitmap_run_optimize(self.ptr)
    }

    /**
    * If needed, reallocate memory to shrink the memory usage. Returns
    * the number of bytes saved.
    */
    public func shrinkToFit() -> size_t {
        return croaring.roaring_bitmap_shrink_to_fit(self.ptr)
    }

    /**
    * write the bitmap to an output pointer, this output buffer should refer to
    * at least roaring_bitmap_size_in_bytes(ra) allocated bytes.
    *
    * see roaring_bitmap_portable_serialize if you want a format that's compatible
    * with Java and Go implementations
    *
    * this format has the benefit of being sometimes more space efficient than
    * roaring_bitmap_portable_serialize
    * e.g., when the data is sparse.
    *
    * Returns how many bytes were written which should be
    * roaring_bitmap_size_in_bytes(ra).
    */
    public func serialize(buffer: inout [Int8]) -> size_t {
        return croaring.roaring_bitmap_serialize(self.ptr, &buffer)
    }

    /**  use with roaring_bitmap_serialize
    * see roaring_bitmap_portable_deserialize if you want a format that's
    * compatible with Java and Go implementations
    */
    public func deserialize(buffer: inout [Int8]) -> RoaringBitmap {
        let rBitmap = RoaringBitmap()
        let ptr = croaring.roaring_bitmap_deserialize(&buffer)!
        rBitmap.ptr = ptr
        return rBitmap
    }

    /**
    * How many bytes are required to serialize this bitmap (NOT compatible
    * with Java and Go versions)
    */
    public func sizeInBytes() -> size_t {
        return croaring.roaring_bitmap_size_in_bytes(self.ptr)
    }

    /**
    * read a bitmap from a serialized version. This is meant to be compatible with
    * the Java and Go versions. See format specification at
    * https://github.com/RoaringBitmap/RoaringFormatSpec
    * In case of failure, a null pointer is returned.
    * This function is unsafe in the sense that if there is no valid serialized
    * bitmap at the pointer, then many bytes could be read, possibly causing a buffer
    * overflow. For a safer approach,
    * call roaring_bitmap_portable_deserialize_safe.
    */
    public func portableDeserialize(buffer: inout [Int8]) -> RoaringBitmap {
        let rBitmap = RoaringBitmap()
        let ptr = croaring.roaring_bitmap_portable_deserialize(&buffer)!
        rBitmap.ptr = ptr
        return rBitmap
    }

    /**
    * read a bitmap from a serialized version in a safe manner (reading up to maxbytes).
    * This is meant to be compatible with
    * the Java and Go versions. See format specification at
    * https://github.com/RoaringBitmap/RoaringFormatSpec
    * In case of failure, a null pointer is returned.
    */
    public func portableDeserializeSafe(buffer: inout [Int8], maxbytes: size_t) -> RoaringBitmap {
        let rBitmap = RoaringBitmap()
        let ptr = croaring.roaring_bitmap_portable_deserialize_safe(&buffer, maxbytes)!
        rBitmap.ptr = ptr
        return rBitmap
    }

    /**
    * Check how many bytes would be read (up to maxbytes) at this pointer if there
    * is a bitmap, returns zero if there is no valid bitmap.
    * This is meant to be compatible with
    * the Java and Go versions. See format specification at
    * https://github.com/RoaringBitmap/RoaringFormatSpec
    */
    public func portableDeserializeSize(buffer: inout [Int8], maxbytes: size_t) -> size_t {
        return croaring.roaring_bitmap_portable_deserialize_size(&buffer, maxbytes)
    }


    /**
    * How many bytes are required to serialize this bitmap (meant to be compatible
    * with Java and Go versions).  See format specification at
    * https://github.com/RoaringBitmap/RoaringFormatSpec
    */
    public func portableSizeInBytes() -> size_t {
        return croaring.roaring_bitmap_portable_size_in_bytes(self.ptr)
    }

    /**
    * write a bitmap to a char buffer.  The output buffer should refer to at least
    *  roaring_bitmap_portable_size_in_bytes(ra) bytes of allocated memory.
    * This is meant to be compatible with
    * the
    * Java and Go versions. Returns how many bytes were written which should be
    * roaring_bitmap_portable_size_in_bytes(ra).  See format specification at
    * https://github.com/RoaringBitmap/RoaringFormatSpec
    */
    public func portableSerialize(buffer: inout [Int8]) -> size_t {
        return croaring.roaring_bitmap_portable_serialize(self.ptr, &buffer)
    }

    /**
    * Return true if the two bitmaps contain the same elements.
    */
    public func equals(x: RoaringBitmap) -> Bool {
        return croaring.roaring_bitmap_equals(self.ptr, x.ptr)

    }

    /**
    * Return true if all the elements of ra1 are also in ra2.
    */
    public func isSubset(x: RoaringBitmap) -> Bool {
        return croaring.roaring_bitmap_is_subset(self.ptr, x.ptr)

    }

    /**
    * Return true if all the elements of ra1 are also in ra2 and ra2 is strictly
    * greater
    * than ra1.
    */
    public func isStrictSubset(x: RoaringBitmap) -> Bool {
        return croaring.roaring_bitmap_is_strict_subset(self.ptr, x.ptr)

    }

    /**
    * (For expert users who seek high performance.)
    *
    * Computes the union between two bitmaps and returns new bitmap. The caller is
    * responsible for memory management.
    *
    * The lazy version defers some computations such as the maintenance of the
    * cardinality counts. Thus you need
    * to call roaring_bitmap_repair_after_lazy after executing "lazy" computations.
    * It is safe to repeatedly call roaring_bitmap_lazy_or_inplace on the result.
    * The bitsetconversion conversion is a flag which determines
    * whether container-container operations force a bitset conversion.
    **/
    public func lazyOr(x: RoaringBitmap, bitsetconversion: Bool) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_lazy_or(self.ptr, x.ptr, bitsetconversion)
        return x2

    }

    /**
    * (For expert users who seek high performance.)
    * Inplace version of roaring_bitmap_lazy_or, modifies x1
    * The bitsetconversion conversion is a flag which determines
    * whether container-container operations force a bitset conversion.
    */
    public func lazyOrInplace(x: RoaringBitmap, bitsetconversion: Bool) {
        croaring.roaring_bitmap_lazy_or_inplace(self.ptr, x.ptr, bitsetconversion)

    }

    /**
    * (For expert users who seek high performance.)
    *
    * Execute maintenance operations on a bitmap created from
    * roaring_bitmap_lazy_or
    * or modified with roaring_bitmap_lazy_or_inplace.
    */
    public func repairAfterLazy() {
        croaring.roaring_bitmap_repair_after_lazy(self.ptr)

    }

    /**
    * Computes the symmetric difference between two bitmaps and returns new bitmap.
    *The caller is
    * responsible for memory management.
    *
    * The lazy version defers some computations such as the maintenance of the
    * cardinality counts. Thus you need
    * to call roaring_bitmap_repair_after_lazy after executing "lazy" computations.
    * It is safe to repeatedly call roaring_bitmap_lazy_xor_inplace on the result.
    *
    */
    public func lazyXor(x: RoaringBitmap) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_lazy_xor(self.ptr, x.ptr)
        return x2

    }

    /**
    * (For expert users who seek high performance.)
    * Inplace version of roaring_bitmap_lazy_xor, modifies x1. x1 != x2
    *
    */
    public func lazyXorInplace(x: RoaringBitmap) {
        croaring.roaring_bitmap_lazy_xor_inplace(self.ptr, x.ptr)

    }

    /**
    * compute the negation of the roaring bitmap within a specified
    * interval: [range_start, range_end). The number of negated values is
    * range_end - range_start.
    * Areas outside the range are passed through unchanged.
    */
    public func flip(rangeStart: UInt64, rangeEnd: UInt64) -> RoaringBitmap {
        let x2 = RoaringBitmap()
        x2.ptr = croaring.roaring_bitmap_flip(self.ptr, rangeStart, rangeEnd)
        return x2

    }

    /**
    * compute (in place) the negation of the roaring bitmap within a specified
    * interval: [range_start, range_end). The number of negated values is
    * range_end - range_start.
    * Areas outside the range are passed through unchanged.
    */
    public func flipInplace(rangeStart: UInt64, rangeEnd: UInt64) {
        croaring.roaring_bitmap_flip_inplace(self.ptr, rangeStart, rangeEnd)
    }

    /**
    * If the size of the roaring bitmap is strictly greater than rank, then this
    function returns true and set element to the element of given rank.
    Otherwise, it returns false.
    */
    public func select(rank: UInt32, element: inout UInt32) -> Bool {
        return croaring.roaring_bitmap_select(self.ptr, rank, &element)

    }
    
    /**
    * roaring_bitmap_rank returns the number of integers that are smaller or equal
    * to x.
    */
    public func rank(x: UInt32) -> UInt64 {
        return croaring.roaring_bitmap_rank(self.ptr, x)

    }

    /**
    * roaring_bitmap_smallest returns the smallest value in the set.
    * Returns UINT32_MAX if the set is empty.
    */
    public func minimum() -> UInt32 {
        return croaring.roaring_bitmap_minimum(self.ptr)

    }

    /**
    * roaring_bitmap_smallest returns the greatest value in the set.
    * Returns 0 if the set is empty.
    */
    public func maximum() -> UInt32 {
        return croaring.roaring_bitmap_maximum(self.ptr)

    }

    /**
    *  (For advanced users.)
    * Collect statistics about the bitmap, see RoaringStatistics.swift for
    * a description of RoaringStatistics
    */
    
    public func statistics() -> RoaringStatistics {
        var stats = RoaringStatistics()
        croaring.roaring_bitmap_statistics(self.ptr, &stats)
        return stats
    }

    /*********************
    * What follows is code use to iterate through values in a roaring bitmap
    */
    public func makeIterator() -> RoaringBitmapIterator {
        return RoaringBitmapIterator(ptr: self.ptr)
    }

    public struct RoaringBitmapIterator: IteratorProtocol {
        private var i: UnsafeMutablePointer<roaring_uint32_iterator_t>
        
        init(ptr: UnsafeMutablePointer<roaring_bitmap_t>) {
            self.i = croaring.roaring_create_iterator(ptr)
        }
        
        mutating public func next() -> UInt32? {
            if(i.pointee.has_value){
                let val = i.pointee.current_value 
                croaring.roaring_advance_uint32_iterator(self.i)
                return val
            }
            return nil
        }
        
    }

}