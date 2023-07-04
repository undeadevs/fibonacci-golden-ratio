using Javis

function ground(args...)
    background("white") # canvas background
    sethue("black") # pen color
end
function part(p=O, r=25, sa=0, ea=2pi, color="black")
    sethue(color)
    setline(2)
    arc(p, r, sa, ea)
    strokepath()
    sethue(color)
    rect_x = p.x
    rect_y = p.y
    eaa = round(ea % 2pi; digits=2)
    if eaa == 3.14
        rect_x = rect_x - r
    elseif eaa == 4.71
        rect_x = rect_x - r
        rect_y = rect_y - r
    elseif eaa == 0
        rect_y = rect_y - r
    end
    rect(rect_x, rect_y, r, r, :stroke)
    return p
end
myvideo = Video(1000, 1000)
Background(1:100, ground)
base_r = 1
n = UInt64(50)

# Object(1:70, (args...) -> object(O, r, 0, pi / 2, "red"), Point(0, 0))
# Object(1:70, (args...) -> object(O, r, pi / 2, pi, "blue"), Point(0, 0 - 0))
# Object(1:70, (args...) -> object(O, r * 2, pi, 3pi / 2, "red"), Point(0 + r, 0))
# Object(1:70, (args...) -> object(O, r * 3, 3pi / 2, 2pi, "blue"), Point(r, 0 + r))
# Object(1:70, (args...) -> object(O, r * 5, 2pi, 5pi / 2, "red"), Point(r - r * 2, r))
# Object(1:70, (args...) -> object(O, r * 8, 5pi / 2, 6pi / 2, "blue"), Point(-r, r - r * 3))
# Object(1:70, (args...) -> object(O, r * 13, 6pi / 2, 7pi / 2, "red"), Point(-r + r * 5, -r * 2))
# Object(1:70, (args...) -> object(O, r * 21, 7pi / 2, 8pi / 2, "blue"), Point(r * 4, -r * 2 + r * 8))
# Object(1:70, (args...) -> object(O, r * 34, 8pi / 2, 9pi / 2, "red"), Point(r * 4 - r * 13, r * 6))
# Object(1:70, (args...) -> object(O, r * 55, 9pi / 2, 10pi / 2, "blue"), Point(-r * 9, r * 6 - r * 21))
# Object(1:70, (args...) -> object(O, r * 89, 10pi / 2, 11pi / 2, "red"), Point(-r * 9 + r * 34, -r * 15))

fib(n::UInt64) = begin
    res::Vector{UInt64} = []
    if n ≥ 0
        push!(res, UInt64(0))
    end
    if n ≥ 1
        push!(res, UInt64(1))
    end
    if n > 1
        (i -> push!(res, res[1+i] + res[2+i])).(0:(n-2))
    end
    return res
end

computed_fib = fib(n)

x = 0
y = 0
sm = 1
for i in 1:n
    global x, y, sm
    arc_color = ""
    if i % 2 == 0
        y = y + (sm * Int64(computed_fib[max(1, i - 1)]))
        arc_color = "blue"
    else
        sm = sm * -1
        x = x + (sm * Int64(computed_fib[max(1, i - 1)]))
        arc_color = "red"
    end

    temp_x = x
    temp_y = y
    Object(1:100, function (_video, _object, frame)
            begin
                scaled_r = base_r/frame
                arc_p = Point(scaled_r * temp_x, scaled_r * temp_y)
                arc_r::Float64 = scaled_r * computed_fib[i+1]
                arc_sa = (i - 1) * (pi / 2)
                arc_ea = (i) * (pi / 2)
                return part(arc_p, arc_r, arc_sa, arc_ea, arc_color)
            end
        end, O)
end

render(
    myvideo;
    pathname="fibonacci.mp4",
    # framerate=50,
    # liveview=true,
)