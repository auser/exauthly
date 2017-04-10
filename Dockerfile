FROM auser/newline:release

EXPOSE 4000

ENTRYPOINT ["/opt/app/bin/newline", "foreground"]

# CMD ["/opt/app/bin/newline", "foreground"]