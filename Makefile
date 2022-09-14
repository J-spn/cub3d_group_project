NAME = cub3D

SRCS_DIR = srcs
OBJS_DIR = objs

SRCS_MF = 	main.c errors.c mlx_init.c utils.c\
			parsing.c parse_identifiers.c parse_map.c\
			check_map.c clear.c

OBJS_M = $(addprefix $(OBJS_DIR)/, $(patsubst %.c,%.o, $(SRCS_MF)))
D_FILES_M = $(addprefix $(OBJS_DIR)/, $(patsubst %.c,%.d, $(SRCS_MF)))

INCLUDES = -I./includes/ -I ./mlx -I libft/includes/

MLX = -Lmlx -lmlx -framework OpenGL -framework AppKit

LIBFT = ./libft/libft.a
LIB_INC = -L./libft/ -lft

#colors
RED 	= 	\033[0;31m
GREEN 	= 	\033[0;32m
BLUE	=	\033[0;34m
BREAK 	= 	\033[0m
YELLOW	=	\033[0;33m

OPFLAGS = -O2
CC = cc
CFLAGS = -g -Wall -Wextra -Werror
SANIT_FLAGS = cc -fsanitize=address $(CFLAGS)

.PHONY : all lib clean fclean sanit_m re

all : lib $(NAME)

$(OBJS_DIR) :
	mkdir $@

lib :
	make -C libft/

$(NAME) : $(OBJS_M) $(LIBFT)
	make -C ./mlx
	$(CC) $(CFLAGS) $(OPFLAGS) $(OBJS_M) $(LIB_INC) $(MLX) -o $(NAME)
	@echo "$(BLUE)$(NAME)$(GREEN) --> DONE!$(BREAK)"

$(OBJS_DIR)/%.o : $(SRCS_DIR)/%.c | $(OBJS_DIR)
	$(CC) $(CFLAGS) $(OPFLAGS) $(INCLUDES) -c $< -o $@ -MD

clean :
	make -C libft/ $@
	make -C ./mlx $@
	rm -rf $(OBJS_DIR)
	@echo "$(BLUE)objs $(RED)--> DELETED$(BREAK)"

fclean : clean
	make -C libft/ $@
	@echo "$(BLUE)libft.a $(RED)--> DELETED$(BREAK)"
	rm -f $(NAME)
	@echo "$(BLUE)$(NAME) $(RED)--> DELETED$(BREAK)"

re : fclean all

re_cub3d : 
	rm -rf $(OBJS_DIR)
	@echo "$(BLUE)objs $(RED)--> DELETED$(BREAK)"
	make all

sanit_m :
	make
	$(SANIT_FLAGS) $(OBJS_M) $(LIB_INC) $(MLX) -o $(NAME)

-include $(D_FILES_M)