/**
 * Значение в msgpack, согласно [спецификации](https://github.com/msgpack/msgpack/blob/master/spec.md).
 */
union Value {
    1: Nil nl
    2: bool bl
    3: i64 int
    4: double flt
    5: string str
    6: binary bin
    7: Object obj
    8: Array arr
}

struct Nil {}
typedef list<Value> Array
typedef map<Value, Value> Object
