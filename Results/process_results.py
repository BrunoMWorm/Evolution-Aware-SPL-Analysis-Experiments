from math import sqrt
import pandas as pd

analyses = [
    "call-density", 
    "case-termination", 
    "dangling-switch", 
    "gotos-density", 
    "return", 
    "return-average"
]

revision_list = [
    "5ab20641d687bfe4d86d255f8c369af54b6026e7",
    "1c31e9e82b12bdceeec4f8e07955984e20ee6b7e",
    "3f2477e8a89ddadd1dfdd9d990ac8c6fdb8ad4b3",
    "31905f94777ae6e7181e9fbcc0cc7c4cf70abfaf",
    "0d6a4ecb30f596570585bbde29f7c9b42a60b623",
    "2f7d9e8903029b1b5e51a15f9cb0dcb6ca17c3ac",
    "6088e138e1c6d0b73f8004fc4b4e9ec40430e18e",
    "0cd4f3039b5a6518eb322f26ed8430529befc3ae",
    "642e71a789156a96bcb18e6c5a0f52416c49d3b5",
    "df1689138e71fa3648209db28146a595c4e63c26"
]

def filter_csv(analysis):

    input_file = f"{analysis}/results/{kebab_to_pascal(analysis)}/stats.csv"

    output_file = f"{analysis}.results.csv"
    processed_output_file = lambda name: f"{analysis}.{name}.results.processed.csv"
    incomplete_analysis_file = f"{analysis}.invalid.csv"

    result_frame = pd.read_csv(input_file)

    # Remove all duplicates (for removing the subheaders that are inserted after each run)
    result_frame.drop_duplicates(subset="Name", keep=False, inplace=True)

    # Splitting the full "Name" into "RName" (Revision+Name) + Strategy,
    # so to filter incomplete analysis using the "RName" column
    result_frame[["RName", "Strategy"]] = result_frame["Name"].str.split(pat="/", n=1, expand=True)
    result_frame.drop(columns=["Name"], inplace=True)

    # Keeping track of all the files that didn't complete
    # We will remove all of them from the final result later
    counts = result_frame["RName"].value_counts()
    incomplete_analysis = result_frame[result_frame["RName"].map(counts) < 4].copy()

    if not incomplete_analysis.empty:
        incomplete_analysis[["Revision", "FileName"]] = incomplete_analysis["RName"].str.split(pat="-", n=1, expand=True)
        incomplete_analysis = incomplete_analysis["FileName"]
        incomplete_analysis.drop_duplicates(inplace=True, keep='first')
    incomplete_analysis.to_csv(incomplete_analysis_file, index=False)

    # This is the step where we remove the incomplete analysis from the result
    result_frame[["Revision", "FileName"]] = result_frame["RName"].str.split(pat="-", n=1, expand=True)
    result_frame.drop(columns=["RName"], inplace=True)
    result_frame = result_frame if incomplete_analysis.empty else result_frame[~result_frame["FileName"].isin(incomplete_analysis)]

    # Sometimes an analysis has finished for a given file in the first revision but not in the others due to timeout
    # Therefore, to not comprimise the analysis, I decided to remove this entry from the input
    # TODO: I must exclude from this rule the file 'procps/pstree.c', as it is
    # inserted between commits '3f2477e8a89ddadd1dfdd9d990ac8c6fdb8ad4b3' and '31905f94777ae6e7181e9fbcc0cc7c4cf70abfaf'
    filename_counts = result_frame['FileName'].value_counts()
    # 10 Commits, 4 values per commit, so the threshold is 10 * 4 = 40
    filenames_to_remove = filename_counts[filename_counts < 40].index
    result_frame.drop(result_frame[result_frame['FileName'].isin(filenames_to_remove)].index, inplace=True)

    # Last step is to filter only the relevant revisions
    # In normal conditions, nothing should happen here. This is only usefull when condidering
    # a subset of the revisions for analysis.
    revision_list_series = pd.Series(revision_list)
    result_frame = result_frame[result_frame["Revision"].isin(revision_list_series)]

    # Ordering to facilitate readability
    desired_order=["Revision","FileName","Strategy","Mean","MeanLB","MeanUB","Stddev","StddevLB","StddevUB"]
    result_frame = result_frame[desired_order]

    result_frame.to_csv(output_file, index=False)

    result_frame["Mean"] = result_frame["Mean"].astype(float)
    result_frame["Stddev"] = result_frame["Stddev"].astype(float)

    memoized_results = result_frame[result_frame['Strategy'] != 'deep']
    non_memoized_results = result_frame[result_frame['Strategy'] == 'deep']

    # Creating the CSV with the processed results
    # The count is useful to visually verify that the number of files analyzed is the same
    memoized_results = memoized_results.groupby(['Revision']).agg(
        Count=('Mean', lambda x: int(x.count() / 3)),
        Stddev=('Stddev', lambda x: sqrt((x**2).sum())),
        Mean=('Mean', lambda x: x.sum())
    ).reset_index()
    non_memoized_results = non_memoized_results.groupby(['Revision']).agg(
        Count=('Mean', lambda x: x.count()),
        Stddev=('Stddev', lambda x: sqrt((x**2).sum())),
        Mean=('Mean', lambda x: x.sum())
    ).reset_index()
    
    # Last step is to sort the CSV with the results, as the 'groupby' function messes with ordering
    # and using 'sort' on groupby does not preserve the order of our commits
    memoized_results['Revision'] = pd.Categorical(memoized_results['Revision'], categories=revision_list, ordered=True)
    memoized_results = memoized_results.sort_values(by=['Revision'])
    memoized_results.insert(1, 'SeqRevision', range(1, 1 + len(memoized_results)))    
    memoized_results['SeqRevision'] = 'R' + memoized_results['SeqRevision'].astype(str)
    
    non_memoized_results['Revision'] = pd.Categorical(non_memoized_results['Revision'], categories=revision_list, ordered=True)
    non_memoized_results = non_memoized_results.sort_values(by=['Revision'])
    non_memoized_results.insert(1, 'SeqRevision', range(1, 1 + len(memoized_results)))    
    non_memoized_results['SeqRevision'] = 'R' + non_memoized_results['SeqRevision'].astype(str)
    
    memoized_results.drop(["Revision","Count"], axis=1).to_csv(processed_output_file('memoized'), index=False)
    non_memoized_results.drop(["Revision","Count"], axis=1).to_csv(processed_output_file('non_memoized'), index=False)

# Helper function to navigate through the folder structure, as the results are inside a folder with 
# a PascalCase name
def kebab_to_pascal(kebab_str):
    return ''.join(word.capitalize() for word in kebab_str.split('-'))

if __name__ == "__main__":
    for analysis in analyses:
        filter_csv(analysis)
