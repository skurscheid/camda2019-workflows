def get_failed_ids(txt_file):
    id = []
    fh = open(txt_file, 'r')
    for row in fh:
        id.append(row.split('/')[1].split('.')[0])
    return(id)

