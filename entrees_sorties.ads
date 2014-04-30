-- ***********************
-- Prologue de compilation
-- ***********************
with TEXT_IO;
with IO_EXCEPTIONS;
-- **************************************
-- Specification du paquetage utilisateur
-- **************************************
package ENTREES_SORTIES is
--  ***********************************************************************
--  Ce paquetage contient un sous-ensemble des operations d'entrees sorties
--     L'utilisateur n'a pas a connaitre la notion de genericite
--     Seules quelques operations concernant
--    les entiers,
--    les flottants,
--    les booleens,
--    les caracteres et
--    les chaines de caracteres
--  sont fournies.
--     ainsi que les exceptions les plus importantes
--       concernant les entrees-sorties
--  ***********************************************************************
-- =========================================================
-- Definition des paquetages necessaires aux entrees-sorties
-- =========================================================
package INT_IO is new text_io.integer_io(integer);
package FLT_IO is new text_io.float_io(float);
package BOOL_IO is new text_io.enumeration_io(boolean);
-- =======================================
-- Renommage de certains types necessaires
-- =======================================
subtype   COUNT           is text_io.count;
subtype   POSITIVE_COUNT  is text_io.positive_count;
subtype   FIELD           is text_io.field;
subtype   NUMBER_BASE     is text_io.number_base;
subtype   TYPE_SET        is text_io.type_set;
-- =================================
-- Renommage de certaines exceptions
-- =================================
DATA_ERROR : exception renames IO_EXCEPTIONS.data_error;
END_ERROR   : exception renames IO_EXCEPTIONS.end_error;
-- ===============================
-- Operations exportees de TEXT_IO
-- ===============================
procedure GET (ITEM: out character)                        renames text_io.get;
procedure PUT (ITEM: in character)                         renames text_io.put;
procedure GET (ITEM: out string)                           renames text_io.get;
procedure PUT (ITEM: in string)                            renames text_io.put;
procedure GET_LINE (ITEM: out string; LAST: out natural) renames text_io.get_line;
procedure PUT_LINE (ITEM: in string)                       renames text_io.put_line;
procedure SKIP_LINE (SPACING : in POSITIVE_COUNT :=1)      renames text_io.skip_line;
procedure NEW_PAGE                                         renames text_io.new_page;
procedure SKIP_PAGE                                        renames text_io.skip_page;
procedure NEW_LINE (SPACING: IN POSITIVE_COUNT:=1)    renames text_io.new_line;
                                                      
procedure SET_COL (TO: in POSITIVE_COUNT)     renames text_io.set_col;
procedure SET_LINE(TO: in POSITIVE_COUNT)                  renames text_io.set_line;
function END_OF_LINE return boolean                      renames text_io.end_of_line;
function END_OF_FILE return boolean  renames text_io.end_of_file;

-- ============================
-- Entrees et sorties d'entiers
-- ============================
procedure GET (ITEM:   out integer;  WIDTH: in field:=0)
                                                              renames INT_IO.get;
              
procedure PUT (ITEM:   in integer;
                WIDTH: in field        := INT_IO.default_width;
                BASE:  in number_base := INT_IO.default_base) renames INT_IO.put;
-- ===============================
-- Entrees et sorties de flottants
-- ===============================
procedure GET (ITEM:   out float;
                WIDTH: in field :=  0)                        renames FLT_IO.get;
procedure PUT (ITEM:   in float;
                FORE:  in field :=  FLT_IO.default_fore;
                AFT:   in field :=  FLT_IO.default_aft;
                EXP:   in field :=  FLT_IO.default_exp)       renames FLT_IO.put;
-- ==============================
-- Entrees et sorties de booleens
-- ==============================
procedure GET (ITEM:   out boolean)                           renames BOOL_IO.get;
procedure PUT (ITEM: in boolean;
                WIDTH: in field     := BOOL_IO.default_width;
                SET:   in text_io.type_set := BOOL_IO.default_setting)
                                                              renames BOOL_IO. put;
end ENTREES_SORTIES;