import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import os


def occupancy_donut(avg_occupancy, out_dir, filename="avg_occupancy.png"):
    """Generates an occupancy donut chart and saves it to a file."""

    # Input validation
    if avg_occupancy is None:
        avg_occupancy = 0
    try:
        avg_occupancy = float(avg_occupancy)
    except (TypeError, ValueError):
        avg_occupancy = 0

    avg_occupancy = max(0, min(100, avg_occupancy))

    # Data setup
    vacant = 100 - avg_occupancy
    sizes = [avg_occupancy, vacant]
    colors = ['#00818a', '#e2e8f0']

    fig, ax = plt.subplots(figsize=(6, 6), dpi=160)

    # Draw Donut
    ax.pie(
        sizes, colors=colors, startangle=90, counterclock=False,
        wedgeprops={'width': 0.35, 'edgecolor': 'white', 'linewidth': 3}
    )

    # Center Text
    ax.text(
        0, 0, f"{avg_occupancy:.1f}%",
        ha='center', va='center',
        fontsize=32, fontweight='bold', color='#001b33'
    )
    ax.set(aspect="equal")

    # Save and Close
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, filename)

    plt.savefig(out_path, bbox_inches="tight", pad_inches=0.02, transparent=True)
    plt.close(fig)  # Important: Release memory

    return out_path


def cancellation_bar(data, out_dir, filename="cancellation_rate.png"):
    """
    Generates a cancellation rate bar chart.
    data format: List of tuples [(YYYY-MM, rate_fraction), ...]
    """
    if not data:
        data = []

    # Process data (Reverse to chronological order)
    data = list(reversed(data))
    months = [row[0] for row in data]
    rates = [float(row[1]) * 100 for row in data]

    if not months:
        months, rates = ["-"], [0]

    fig, ax = plt.subplots(figsize=(12, 6), dpi=170)
    bars = ax.bar(months, rates, width=0.55)

    # Dynamic Y-axis scaling
    max_rate = max(rates) if rates else 0
    if len(rates) == 1:
        y_top = 10 if max_rate <= 1 else max(15, max_rate * 2)
    else:
        y_top = max(10, min(100, max_rate * 1.35 + 2))

    ax.set_ylim(0, y_top)

    # Styling
    ax.grid(axis='y', linestyle='--', alpha=0.25)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['bottom'].set_color('#cbd5e1')
    ax.tick_params(axis='both', which='both', length=0)

    # Add labels on bars
    for i, bar in enumerate(bars):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + (y_top * 0.03),
            f"{rates[i]:.1f}%",
            ha="center", va="bottom",
            fontsize=12, fontweight="bold"
        )

    if len(months) > 8:
        plt.xticks(rotation=25, ha='right')

    plt.tight_layout()

    # Save and Close
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, filename)

    plt.savefig(out_path, bbox_inches="tight", pad_inches=0.02, transparent=True)
    plt.close(fig)  # Important: Release memory

    return out_path
