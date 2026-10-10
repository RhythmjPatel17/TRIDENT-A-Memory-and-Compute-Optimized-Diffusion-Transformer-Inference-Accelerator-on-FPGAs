class MockLayer:

    def __init__(self, layer_id, refresh_interval):
        self.layer_id = layer_id
        self.refresh_interval = refresh_interval
        self.step = 0
        self.cached_idx = None
        self.log = []

    def set_step(self, step_idx):
        self.step = step_idx

    def is_refresh_step(self):
        return self.step % self.refresh_interval == 0

    def run(self):
        if self.is_refresh_step():
            self.cached_idx = f'idx(layer={self.layer_id},step={self.step})'
            self.log.append(('refresh', self.step, self.cached_idx))
        else:
            assert self.cached_idx is not None, f'layer {self.layer_id} step {self.step}: reuse before any refresh'
            self.log.append(('reuse', self.step, self.cached_idx))

def simulate(depth, t_steps, refresh_interval):
    layers = [MockLayer(l, refresh_interval) for l in range(depth)]
    for step in range(t_steps):
        for layer in layers:
            layer.set_step(step)
            layer.run()
    return layers

def check(depth, t_steps, refresh_interval):
    layers = simulate(depth, t_steps, refresh_interval)
    for layer in layers:
        for kind, step, idx in layer.log:
            expected_kind = 'refresh' if step % refresh_interval == 0 else 'reuse'
            assert kind == expected_kind, (layer.layer_id, step, kind, expected_kind)
            if kind == 'reuse':
                last_refresh_step = step // refresh_interval * refresh_interval
                expected_idx = f'idx(layer={layer.layer_id},step={last_refresh_step})'
                assert idx == expected_idx, (layer.layer_id, step, idx, expected_idx)
    return True
if __name__ == '__main__':
    configs = [(12, 50, 1), (12, 50, 8), (12, 50, 50), (12, 2, 8), (1, 10, 3), (6, 17, 5)]
    for depth, t_steps, r in configs:
        ok = check(depth, t_steps, r)
        n_refresh = sum((1 for s in range(t_steps) if s % r == 0))
        n_reuse = t_steps - n_refresh
        print(f"DEPTH={depth:2d} T_STEPS={t_steps:3d} R={r:2d}: OK -- {n_refresh} refresh-steps, {n_reuse} reuse-steps, each layer's cache correctly traced to its own last refresh")
    print()
    print('ALL SCHEDULER LOGIC CHECKS PASSED')
