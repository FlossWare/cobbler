- name: Setup 
        run: | 
          git config --global user.name "Git Action"
          git config --global user.email github-action@noreply.com
          
          git submodule foreach git checkout master
          git submodule foreach git pull
          git submodule update --remote --merge

          cd ${GITHUB_WORKSPACE}
          echo "Dir contains:"
          ls -la
          echo "FlossWare scripts contains:"
          ls -la flossware-scripts
          echo "Workspace:  ${GITHUB_WORKSPACE}"
          echo "Files in flossware-scripts:"
          find ${GITHUB_WORKSPACE}/flossware-scripts/bash
          echo "FlossWare-scripts branch:"
          cd ${GITHUB_WORKSPACE}/flossware-scripts
          git branch
          cd -
          ${GITHUB_WORKSPACE}/flossware-scripts/bash/continuous-delivery/prepare-rpm-git-release.sh flossware.spec
          ./buildrpm.sh ${GITHUB_WORKSPACE}/../rpmbuilds
          ${GITHUB_WORKSPACE}/flossware-scripts/bash/git/push-current-branch-to-gitrepo.sh
          ${GITHUB_WORKSPACE}/flossware-scripts/bash/bintray/rpm-publish.sh --bintrayUser sfloess --bintrayKey ${{ secrets.BINTRAY_API_KEY }} --bintrayAccount flossware --bintrayRepo rpm --bintrayPackage cobbler --bintrayFile ${GITHUB_WORKSPACE}/../rpmbuilds/rpm/RPMS/noarch/`ls -t ${GITHUB_WORKSPACE}/../rpmbuilds/rpm/RPMS/noarch  | head -1` --bintrayContext flossware.spec
