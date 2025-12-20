import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
from matplotlib.cm import ScalarMappable

# -----------------------
# Parameters
# -----------------------
np.random.seed(7)

n_cells = 6
particles_per_cell = 8

grid_x = np.linspace(0, 1, n_cells + 1)
grid_y = np.linspace(0, 1, n_cells + 1)
cell_w = grid_x[1] - grid_x[0]
cell_h = grid_y[1] - grid_y[0]

# -----------------------
# Generate particles
# -----------------------
positions = []
velocities = []

for i in range(n_cells):
    for j in range(n_cells):
        base_v = np.array([
            0.6 + 0.2 * np.cos(2 * np.pi * grid_y[j]),
            0.2 * np.sin(2 * np.pi * grid_x[i])
        ])

        for _ in range(particles_per_cell):
            pos = [
                grid_x[i] + np.random.rand() * cell_w,
                grid_y[j] + np.random.rand() * cell_h
            ]
            vel = base_v + 0.08 * np.random.randn(2)

            positions.append(pos)
            velocities.append(vel)

positions = np.array(positions)
velocities = np.array(velocities)

speed = np.linalg.norm(velocities, axis=1)
vel_unit = velocities / speed[:, None]

# -----------------------
# Selected cell (red square)
# -----------------------
cell_i, cell_j = 3, 2
cell_x = grid_x[cell_i]
cell_y = grid_y[cell_j]

inside = (
    (positions[:, 0] >= cell_x) &
    (positions[:, 0] <= cell_x + cell_w) &
    (positions[:, 1] >= cell_y) &
    (positions[:, 1] <= cell_y + cell_h)
)

# -----------------------
# Lattice directions (D2Q9 without rest)
# -----------------------
directions = np.array([
    [1, 0], [-1, 0], [0, 1], [0, -1],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
])
directions = directions / np.linalg.norm(directions, axis=1)[:, None]

# Project particle velocities onto lattice directions
global_flux = []
for d in directions:
    proj = np.dot(velocities[inside], d)
    global_flux.append(proj.mean())

global_flux = np.array(global_flux)

# -----------------------
# Figure layout
# -----------------------
fig, (ax, ax_zoom) = plt.subplots(1, 2, figsize=(12, 6))

norm = Normalize(vmin=speed.min(), vmax=speed.max())
cmap = plt.cm.coolwarm

# -----------------------
# Main plot
# -----------------------
ax.quiver(
    positions[:, 0], positions[:, 1],
    vel_unit[:, 0], vel_unit[:, 1],
    speed,
    cmap=cmap,
    norm=norm,
    scale_units='xy',
    scale=35,
    width=0.004,
    alpha=1.0
)

# Grid
ax.set_xticks(grid_x)
ax.set_yticks(grid_y)
ax.grid(True, color='gray', alpha=0.25, linewidth=0.7)
ax.set_xticklabels([])
ax.set_yticklabels([])

# Red square
ax.add_patch(
    plt.Rectangle(
        (cell_x, cell_y),
        cell_w,
        cell_h,
        edgecolor='crimson',
        facecolor='none',
        lw=2.5
    )
)

ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
ax.set_aspect('equal')
ax.set_title("Microscopic particle populations")

# -----------------------
# Colorbar (Low / High only)
# -----------------------
cbar = fig.colorbar(
    ScalarMappable(norm=norm, cmap=cmap),
    ax=ax,
    fraction=0.045,
    pad=0.04
)
cbar.set_ticks([speed.min(), speed.max()])
cbar.set_ticklabels(["Low", "High"])
cbar.set_label("Velocity magnitude")

# -----------------------
# Zoom subplot (LBM explanation)
# -----------------------
ax_zoom.set_title("Lattice cell interpretation (LBM)")

# Particle velocities inside cell
ax_zoom.quiver(
    positions[inside, 0], positions[inside, 1],
    vel_unit[inside, 0], vel_unit[inside, 1],
    speed[inside],
    cmap=cmap,
    norm=norm,
    scale_units='xy',
    scale=25,
    width=0.005,
    alpha=1.0
)

# Central lattice node
center = np.array([cell_x + cell_w / 2, cell_y + cell_h / 2])
ax_zoom.scatter(*center, color='black', s=50, zorder=3)

# Global lattice directions using quiver - D2Q8 visualization
# centers_x = np.full(len(directions), center[0])
# centers_y = np.full(len(directions), center[1])
#
# # Scale factor for better visibility
# arrow_scale = 0.15  # Adjust this to make arrows more visible
#
# ax_zoom.quiver(
#     centers_x, centers_y,
#     arrow_scale * directions[:, 0],          # Fixed length for direction visibility
#     arrow_scale * directions[:, 1],          # Fixed length for direction visibility
#     global_flux,                             # Color by flux magnitude
#     scale_units='xy',
#     scale=10,                                 # No additional scaling
#     width=0.008,
#     alpha=1.0,
#     headwidth=4,
#     headlength=5
# )
#
# Global lattice directions using quiver - D2Q8 visualization with directional emphasis
centers_x = np.full(len(directions), center[0])
centers_y = np.full(len(directions), center[1])

# Scale factors
min_arrow_scale = 0.15  # Small default size for counter-flux
flux_scale = 1.        # Scale factor for actual flux

# Determine which directions have positive flux (outgoing)
flux_magnitude = global_flux
arrow_dx = np.zeros(len(directions))
arrow_dy = np.zeros(len(directions))

for i in range(len(directions)):
    if flux_magnitude[i] > 0:  # Positive flux - make it larger
        if flux_magnitude[i] < 0.2:
            flux_magnitude[i] = 0.2
        arrow_dx[i] = flux_scale * flux_magnitude[i] * directions[i, 0]
        arrow_dy[i] = flux_scale * flux_magnitude[i] * directions[i, 1]
    else:  # Negative or zero flux - small default size
        arrow_dx[i] = min_arrow_scale * directions[i, 0]
        arrow_dy[i] = min_arrow_scale * directions[i, 1]

ax_zoom.quiver(
    centers_x, centers_y,
    arrow_dx, arrow_dy,
    color='black',
    scale_units='xy',
    scale=10,
    width=0.008,
    alpha=1.0,
    angles='xy',
    headwidth=4,
    headlength=5
)

# Global lattice directions using quiver - D2Q8 visualization
# centers_x = np.full(len(directions), center[0])
# centers_y = np.full(len(directions), center[1])
#
# # Scale factor for better visibility
# arrow_scale = 0.15  # Fixed scale for minimum arrow length
#
# # Calculate arrow components - take maximum between fixed scale and flux scale
# arrow_dx = np.sign(directions[:, 0]) * np.maximum(
#     np.abs(arrow_scale * directions[:, 0]),
#     np.abs(global_flux * directions[:, 0])
# )
#
# arrow_dy = np.sign(directions[:, 1]) * np.maximum(
#     np.abs(arrow_scale * directions[:, 1]),
#     np.abs(global_flux * directions[:, 1])
# )
#
# ax_zoom.quiver(
#     centers_x, centers_y,
#     arrow_dx, arrow_dy,
#     color='black',                           # Black arrows
#     scale_units='xy',
#     scale=10,
#     width=0.008,
#     alpha=1.0,
#     angles='xy',
#     headwidth=4,
#     headlength=5
# )

# Global lattice directions using quiver
# centers_x = np.full(len(directions), center[0])
# centers_y = np.full(len(directions), center[1])
#
# ax_zoom.quiver(
#     centers_x, centers_y,                    # Starting points (center repeated for each direction)
#     global_flux * directions[:, 0],          # X components scaled by flux
#     global_flux * directions[:, 1],          # Y components scaled by flux
#     global_flux,                             # Color mapping
#     cmap='RdYlGn',                           # Colormap
#     scale_units='xy',
#     scale=10,                                # Adjust scale as needed
#     width=0.005,
#     alpha=1.0,
#     angles='xy',
#     headwidth=3,
#     headlength=4
# )

# Global lattice directions
# for d, f in zip(directions, global_flux):
#     ax_zoom.arrow(
#         center[0], center[1],
#         0.25 * f * d[0],
#         0.25 * f * d[1],
#         width=0.01,
#         head_width=0.05,
#         color='black',
#         length_includes_head=True
#     )

ax_zoom.set_xlim(cell_x, cell_x + cell_w)
ax_zoom.set_ylim(cell_y, cell_y + cell_h)
ax_zoom.set_aspect('equal')
ax_zoom.set_xticks([])
ax_zoom.set_yticks([])

plt.tight_layout()
plt.show()

