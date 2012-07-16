#ifndef SL_PARSE_H
#define SL_PARSE_H

#include "vm.h"
#include "lex.h"
#include "ast.h"
#include "eval.h"

typedef struct {
    sl_vm_t* vm;
    sl_token_t* tokens;
    size_t token_count;
    size_t current_token;
    uint8_t* filename;
    sl_node_base_t* ast;
}
sl_parse_state_t;

sl_node_base_t*
sl_parse(sl_vm_t* vm, sl_token_t* tokens, size_t token_count, uint8_t* filename);

sl_node_seq_t*
sl_make_seq_node();

void
sl_seq_node_append(sl_node_seq_t* seq, sl_node_base_t* node);

sl_node_base_t*
sl_make_raw_node(sl_parse_state_t* ps, sl_token_t* token);

sl_node_base_t*
sl_make_echo_node(sl_node_base_t* expr);

sl_node_base_t*
sl_make_raw_echo_node(sl_node_base_t* expr);

sl_node_base_t*
sl_make_binary_node(sl_node_base_t* left, sl_node_base_t* right, sl_node_type_t type, SLVAL(*eval)(sl_node_binary_t*,sl_eval_ctx_t*));

sl_node_base_t*
sl_make_unary_node(sl_node_base_t* expr, sl_node_type_t type, SLVAL(*eval)(sl_node_unary_t*,sl_eval_ctx_t*));

sl_node_base_t*
sl_make_immediate_node(SLVAL val);

sl_node_base_t*
sl_make_send_node(sl_parse_state_t* ps, sl_node_base_t* recv, char* id, size_t argc, sl_node_base_t** argv);

#endif