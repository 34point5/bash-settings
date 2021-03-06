# ~/.bash_aliases

# WSL: set up a virtual display using VcXsrv to run Qt and other GUI apps.
export DISPLAY=localhost:0.0
export GDK_SCALE=1
export LIBGL_ALWAYS_INDIRECT=1
export XDG_RUNTIME_DIR=/tmp/runtime-tfpf
alias vcx='/mnt/c/Program\ Files/VcXsrv/xlaunch.exe'

# WSL: prevent exit failure if the previous command failed.
alias exit='clear && exit'

# Some sort of a system monitor.
alias F='watch -n 0.1 "cat /proc/cpuinfo | grep MHz"'
alias M='watch -n 0.1 free -ht'

alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias ls='ls -C --color=auto'
alias lt='ls -hlNtr --color=auto --group-directories-first --time-style=long-iso'

alias grep='grep --binary-files=without-match --color=auto'

alias pgrep='pgrep -il'

alias ps='ps -e | sort -gr'

# Run a PowerShell script without globally changing the execution policy.
alias psh='powershell.exe -ExecutionPolicy Bypass'

alias p='/usr/local/bin/python3.8 -B'
alias t='/usr/local/bin/python3.8 -m timeit'
alias pip='/usr/local/bin/python3.8 -m pip'

alias time='/usr/bin/time -f "----------\n%e s, %M kB (max)\n%I FS inputs, %O FS outputs, %W swaps\n%F major PFs, %R minor PFs\n----------\n" '

alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose'

# Commit and push changes to the master branch of a GitHub repository.
push ()
{
    if [[ $# -lt 2 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} \"commit message\" file1 [file2] [file3] [...]\n"
        return 1
    fi

    local args=( "$@" )
    local files=("${args[@]:1}")

    git add ${files[*]}
    git commit -m "$1"
    git push origin master
}


# Windows Explorer can open WSL folders, but the command must be invoked from
# within the WSL folder to be opened. This is a convenience function to do
# that.
e ()
{
    if [[ $# -lt 1 || ! -d "$1" ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} dirpath\n"
        return 1
    fi

    local dirpath="$1"
    bash -c "cd '$dirpath' && explorer.exe ."
}

# Just like Windows Explorer, to open WSL files using GVIM, the command must be
# invoked from within the folder containing the file.
g ()
{
    if [[ $# -lt 1 || ! -f "$1" ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} filepath\n"
        return 1
    fi

    local gvimpath='/mnt/c/Program Files (x86)/Vim/vim82/gvim.exe'
    local dirpath=$(dirname "$1")
    local filename=$(basename "$1")
    bash -c "cd '$dirpath' && '$gvimpath' '$filename' &"
}

# PDF optimiser. This requires that `ghostscript' be installed.
pdfopt ()
{
    if [[ $# -lt 2 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} input_file.pdf output_file.pdf [resolution]\n"
        return 1
    fi

    if [[ $# -ge 3 ]]
    then
        opt_level=$3
    else
        opt_level=72
    fi

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress     \
       -dNOPAUSE -dQUIET -dBATCH                                              \
       -sOutputFile=$2                                                        \
       -dDownsampleColorImages=true -dColorImageResolution=$opt_level         \
       -dDownsampleGrayImages=true  -dGrayImageResolution=$opt_level          \
       -dDownsampleMonoImages=true  -dMonoImageResolution=$opt_level          \
       $1
}

executor_icon_data='\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x14\x00\x00\x00\x14\x08\x06\x00\x00\x00\x8d\x89\x1d\r\x00\x00\x00gIDAT8\x11\xad\xc1A\x11\x000\x10\x840\xf0/\x9a\x1a\xd8\xd7M\x13+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06\x81\xf8H >\x12\x88\x8f\x04\xe2#+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x86\x07\xc6\x97D\x01a\xc1\x9d\x0b\x00\x00\x00\x00IEND\xaeB`\x82'

# A little hack to run Python programs without writing to a file. Open a
# Tkinter window and read the file. Execute the program when the F1 key is
# pressed. This should work on all single-threaded Python programs which do not
# create any Tkinter widgets. The random names should prevent name collisions.
P ()
{
    if [[ $# -lt 1 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} file\n"
        return 1
    fi

    p -c "
import tkinter as _ArFfEXZloCCjFNnmSwdw

def _sQIvYlfwvgZJnQNmxRyF(event):
    command = event.widget.get('1.0', _ArFfEXZloCCjFNnmSwdw.END)
    try:
        exec(command, globals(), globals())
    except Exception as e:
        print(e)

def _xtBzBMfnpdQGhwINyACP():
    root = _ArFfEXZloCCjFNnmSwdw.Tk()
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data = b'$executor_icon_data'))
    root.title('Python Executor')

    kwargs = {'bg':               '#333333',
              'fg':               '#CCCCCC',
              'insertbackground': '#CCCCCC',
              'font':             ('Cascadia Code', 13),
              'wrap':             'none',
             }
    text = _ArFfEXZloCCjFNnmSwdw.Text(root, height = 40, width = 150, **kwargs)
    text.insert('1.0', open('$1').read())
    text.focus_set()
    text.mark_set('insert', '1.0')
    text.bind('<F1>', _sQIvYlfwvgZJnQNmxRyF)
    text.grid(row = 0, column = 0)

    root.mainloop()

_xtBzBMfnpdQGhwINyACP()
"
}

# Just like the last one, this is a hack to render LaTeX expression without
# creating a new file. Uses the Tex parser that comes with Matplotlib.
L ()
{
    p -c "
import matplotlib as _EhdhMmAprSRzwpUPoHvW; _EhdhMmAprSRzwpUPoHvW.use('TkAgg')
import matplotlib.backends.backend_tkagg as _hNzVCYEPlZTSmIqqKOhB
import matplotlib.figure as _WFHjDXaGDEVBLyVLsdmR
import tkinter as _ArFfEXZloCCjFNnmSwdw

def _sQIvYlfwvgZJnQNmxRyF(ax, text, entry):
    ax.texts = []
    try:
        ax.text(0, 0, text.get('1.0', _ArFfEXZloCCjFNnmSwdw.END), size = int(entry.get()), color = '#CCCCCC')
    except Exception as e:
        print(e)
    ax.figure.canvas.draw()

def _xtBzBMfnpdQGhwINyACP():
    root = _ArFfEXZloCCjFNnmSwdw.Tk()
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data = b'$executor_icon_data'))
    root.title('LaTeX Renderer')

    fig = _WFHjDXaGDEVBLyVLsdmR.Figure()
    fig.patch.set_facecolor('#333333')
    ax = fig.add_subplot()
    ax.axis('off')
    ax.set_xlim(0, 100)
    ax.set_ylim(0, 100)
    canvas = _hNzVCYEPlZTSmIqqKOhB.FigureCanvasTkAgg(fig, master = root)
    canvas.draw()
    canvas.get_tk_widget().grid(row = 0, column = 0, rowspan = 2)

    kwargs = {'bg':               '#333333',
              'fg':               '#CCCCCC',
              'insertbackground': '#CCCCCC',
              'font':             ('Cascadia Code', 13),
             }
    text = _ArFfEXZloCCjFNnmSwdw.Text(root, height = 20, width = 60, **kwargs)
    root.after(1000, text.focus_set)
    text.bind('<F1>', lambda event: _sQIvYlfwvgZJnQNmxRyF(ax, text, entry))
    text.grid(row = 0, column = 1)
    entry = _ArFfEXZloCCjFNnmSwdw.Entry(root, width = 60, **kwargs)
    entry.insert(0, '20')
    entry.bind('<F1>', lambda event: _sQIvYlfwvgZJnQNmxRyF(ax, text, entry))
    entry.grid(row = 1, column = 1)

    root.mainloop()

_xtBzBMfnpdQGhwINyACP()
"
}
