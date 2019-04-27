
def fastp_targets(md5check):
    """function for filtering dsrc files with failed md5sum check"""
    t = []
    for index, row in units.iterrows():
        t.append(row['batch'] + "/" + row['sample'] + "_" + row['condition'] + "_" + row['lane'] + "_" + str(row['replicate']))
    return(t)


# Main method.
if __name__ == '__main__':
    run_script()