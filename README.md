# Video Trimmer Script

This Bash script trims the last specified number of seconds from a video file using `ffmpeg`. It takes the input video file, output video file, and duration to trim from the end as command-line parameters.

## Prerequisites

- Ubuntu operating system
- `ffmpeg` installed
- `bc` installed

The script will check for `ffmpeg` and `bc` and install them if they are not already installed.

## Usage

1. **Download the Script**

Save the script to a file, e.g., `trim_video.sh`.

2. **Make the Script Executable**

   Open a terminal and run the following command to make the script executable:

```bash
chmod +x trim_video.sh
```

3. **Run the Script**

Run the script with the required parameters:

```bash
./trim_video.sh -i path/to/your/video.mp4 -o path/to/your/output_video.mp4 -d duration_to_trim_in_seconds
```

- i: Path to the input video file.
- o: Path to the output video file.
- d: Duration to trim from the end of the video (in seconds).

## Example

```bash
./trim_video.sh -i input_video.mp4 -o output_video.mp4 -d 1320
```

## License

This script is provided "as-is" without any warranty. Use at your own risk.

