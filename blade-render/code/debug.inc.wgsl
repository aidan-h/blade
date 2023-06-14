struct DebugPoint {
    pos: vec3<f32>,
    color: u32,
}
struct DebugLine {
    a: DebugPoint,
    b: DebugPoint,
}
struct DebugVariance {
    color_sum: vec3<f32>,
    color2_sum: vec3<f32>,
    count: u32,
}
struct DebugBuffer {
    vertex_count: u32,
    instance_count: atomic<u32>,
    first_vertex: u32,
    first_instance: u32,
    capacity: u32,
    open: u32,
    variance: DebugVariance,
    lines: array<DebugLine>,
}

var<storage, read_write> debug_buf: DebugBuffer;

fn debug_line(a: vec3<f32>, b: vec3<f32>, color: u32) {
    if (debug_buf.open != 0u) {
        let index = atomicAdd(&debug_buf.instance_count, 1u);
        if (index < debug_buf.capacity) {
            debug_buf.lines[index] = DebugLine(DebugPoint(a, color), DebugPoint(b, color));
        } else {
            // ensure the final value is never above the capacity
            atomicSub(&debug_buf.instance_count, 1u);
        }
    }
}
