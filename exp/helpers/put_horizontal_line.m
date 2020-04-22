function put_horizontal_line(val, linespec)

    hold on;
    my_lim = get(gca,'YLim');
    plot([val, val], [my_lim(1),my_lim(2)], linespec);
    hold off;

end